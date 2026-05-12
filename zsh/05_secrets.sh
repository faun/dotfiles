# macOS Keychain-backed env var loader, sourced by interactive zsh.
# Keep this file POSIX-clean inside an interactive shell — no `set -e` etc.
#
# Conventions:
#   - One 1Password item holds many fields, one per secret.
#   - Field label in 1Password == env var name == Keychain service name.
#   - Item is referenced only by UUID (vault UUID + item UUID).
#   - Cached secret names are tracked in $SECRET_STORE_INDEX so shell
#     startup can enumerate without dumping the whole Keychain.
#
# Required env vars (set in ~/.local.sh):
#   OP_SECRETS_VAULT  — vault UUID
#   OP_SECRETS_ITEM   — item UUID
#   OP_ACCOUNT        — 1Password account (e.g. gustohq.1password.com)
#
# Bootstrap a new machine with `secret_store_all`; thereafter every cached
# secret auto-loads on shell start.

# macOS-only: relies on `security` (macOS Keychain CLI).
[[ "$OSTYPE" == darwin* ]] || return 0

: "${SECRET_STORE_INDEX:=${XDG_CONFIG_HOME:-$HOME/.config}/secret_store/names}"

_secret_op_args() {
  # Print optional --account flag pair, one per line, for safe array capture.
  [[ -n "${OP_ACCOUNT:-}" ]] && printf '%s\n' --account "$OP_ACCOUNT"
}

_secret_index_add() {
  local name="$1" dir
  dir=${SECRET_STORE_INDEX:h}
  [[ -d "$dir" ]] || mkdir -p "$dir"
  [[ -f "$SECRET_STORE_INDEX" ]] || : > "$SECRET_STORE_INDEX"
  grep -qxF -- "$name" "$SECRET_STORE_INDEX" || printf '%s\n' "$name" >> "$SECRET_STORE_INDEX"
}

_secret_index_remove() {
  local name="$1" tmp
  [[ -f "$SECRET_STORE_INDEX" ]] || return 0
  tmp=$(mktemp) || return 1
  grep -vxF -- "$name" "$SECRET_STORE_INDEX" > "$tmp"
  mv "$tmp" "$SECRET_STORE_INDEX"
}

# secret_store <NAME>
#   Read field <NAME> from the configured 1Password item, cache the value
#   in the macOS Keychain under service <NAME>, and add <NAME> to the index.
secret_store() {
  local name="$1"
  if [[ -z "$name" ]]; then
    echo "usage: secret_store <NAME>" >&2
    return 2
  fi
  if [[ -z "${OP_SECRETS_VAULT:-}" || -z "${OP_SECRETS_ITEM:-}" ]]; then
    echo "secret_store: OP_SECRETS_VAULT and OP_SECRETS_ITEM must be set" >&2
    return 1
  fi
  local op_uri="op://${OP_SECRETS_VAULT}/${OP_SECRETS_ITEM}/${name}"
  # `op read` doesn't accept --account; it picks up OP_ACCOUNT from the env.
  local value op_err
  op_err=$(mktemp)
  if ! value=$(op read --no-newline "$op_uri" 2>"$op_err"); then
    echo "secret_store: failed to read $name from 1Password" >&2
    sed 's/^/  /' "$op_err" >&2
    rm -f "$op_err"
    return 1
  fi
  rm -f "$op_err"
  if security add-generic-password -U \
    -a "$USER" -s "$name" -w "$value" \
    -T /usr/bin/security >/dev/null 2>&1; then
    _secret_index_add "$name"
    echo "secret_store: stored $name in Keychain"
  else
    echo "secret_store: failed to write $name to Keychain" >&2
    return 1
  fi
}

# secret_store_all
#   Fetch every populated field on the configured 1Password item and cache
#   each value in the Keychain. Use to bootstrap a new machine or refresh.
secret_store_all() {
  if [[ -z "${OP_SECRETS_VAULT:-}" || -z "${OP_SECRETS_ITEM:-}" ]]; then
    echo "secret_store_all: OP_SECRETS_VAULT and OP_SECRETS_ITEM must be set" >&2
    return 1
  fi
  local op_args=()
  [[ -n "${OP_ACCOUNT:-}" ]] && op_args=(--account "$OP_ACCOUNT")
  local labels
  if ! labels=$(op item get "$OP_SECRETS_ITEM" --vault "$OP_SECRETS_VAULT" \
                  "${op_args[@]}" --format json 2>/dev/null \
                | jq -r '.fields[] | select(.value != null and .value != "") | .label'); then
    echo "secret_store_all: failed to list fields from 1Password" >&2
    return 1
  fi
  local name
  while IFS= read -r name; do
    [[ -n "$name" ]] && secret_store "$name"
  done <<< "$labels"
}

# secret_delete <NAME>
secret_delete() {
  if [[ -z "${1:-}" ]]; then
    echo "usage: secret_delete <NAME>" >&2
    return 2
  fi
  if security delete-generic-password -a "$USER" -s "$1" >/dev/null 2>&1; then
    _secret_index_remove "$1"
    echo "secret_delete: removed $1"
  else
    _secret_index_remove "$1"
    echo "secret_delete: $1 not found"
  fi
}

# secret_load <NAME>
#   Read cached secret <NAME> from the Keychain and export it as $NAME.
#   Silent on miss so shell startup never blocks or prints noise.
secret_load() {
  local name="$1"
  local value
  value=$(security find-generic-password -a "$USER" -s "$name" -w 2>/dev/null) || return 0
  [[ -n "$value" ]] && export "$name=$value"
}

# Auto-load every secret named in the index.
if [[ -f "$SECRET_STORE_INDEX" ]]; then
  while IFS= read -r _name; do
    [[ -n "$_name" ]] && secret_load "$_name"
  done < "$SECRET_STORE_INDEX"
  unset _name
fi
