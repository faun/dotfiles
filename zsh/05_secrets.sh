# 1Password-sourced env var loader with a local cache, sourced by interactive zsh.
# Keep this file POSIX-clean inside an interactive shell — no `set -e` etc.
#
# Cache backends:
#   - macOS: the login Keychain (`security`), service name == env var name.
#   - Linux: one `systemd-creds encrypt --user` blob per secret in
#     $SECRET_STORE_DIR/<NAME>.cred (dir 0700, files 0600). The blob is
#     bound to this host's credential key (and TPM2 when present), to this
#     UID, and to <NAME>, so a copied or renamed file won't decrypt. Without
#     a TPM, root or anyone with the raw disk can still recover the host key.
#     Needs systemd >= 256; there is no plaintext fallback.
#
# Conventions:
#   - One 1Password item holds many fields, one per secret.
#   - Field label in 1Password == env var name == cache entry name.
#   - Item is referenced only by UUID (vault UUID + item UUID).
#   - Cached secret names are tracked in $SECRET_STORE_INDEX so shell
#     startup can enumerate without dumping the whole cache.
#
# Required env vars (set in ~/.local.sh):
#   OP_SECRETS_VAULT  — vault UUID
#   OP_SECRETS_ITEM   — item UUID
#   OP_ACCOUNT        — 1Password account (e.g. gustohq.1password.com)
#
# Bootstrap a new machine with `secret_store_all`; thereafter every cached
# secret auto-loads on shell start.

: "${SECRET_STORE_INDEX:=${XDG_CONFIG_HOME:-$HOME/.config}/secret_store/names}"
: "${SECRET_STORE_DIR:=${XDG_CONFIG_HOME:-$HOME/.config}/secret_store/values}"

if [[ "$OSTYPE" == darwin* ]]; then
  _SECRET_BACKEND_NAME=Keychain
else
  _SECRET_BACKEND_NAME="systemd-creds ($SECRET_STORE_DIR)"
fi

# Names become file paths and credential names, so only allow env-var names.
_secret_valid_name() {
  [[ "$1" =~ '^[A-Za-z_][A-Za-z0-9_]*$' ]]
}

# _secret_backend_write <NAME> <VALUE>
_secret_backend_write() {
  setopt localoptions noxtrace
  local name="$1" value="$2"
  if [[ "$OSTYPE" == darwin* ]]; then
    security add-generic-password -U \
      -a "$USER" -s "$name" -w "$value" \
      -T /usr/bin/security >/dev/null 2>&1
    return
  fi
  if ! (( $+commands[systemd-creds] )); then
    echo "secret_store: systemd-creds not found; refusing to cache $name in plaintext" >&2
    return 1
  fi
  local tmp err
  # umask in a subshell so the dir and temp file are never briefly readable.
  (umask 077 && mkdir -p "$SECRET_STORE_DIR") || return 1
  chmod 700 "$SECRET_STORE_DIR" || return 1
  tmp=$(umask 077 && mktemp "$SECRET_STORE_DIR/.${name}.XXXXXX") || return 1
  # The value goes in on stdin (printf is a builtin), never on argv where
  # `ps` could see it. --name binds the blob to <NAME>. Output goes to
  # stdout into the mktemp file, because given a path systemd-creds
  # replaces it with a 0644 file.
  if err=$(printf '%s' "$value" \
        | systemd-creds encrypt --user --name="$name" - - 2>&1 >"$tmp") \
     && mv -f "$tmp" "$SECRET_STORE_DIR/$name.cred"; then
    return 0
  fi
  [[ -n "$err" ]] && printf '  %s\n' "$err" >&2
  rm -f "$tmp"
  return 1
}

# _secret_backend_read <NAME> — prints the value; non-zero on miss.
_secret_backend_read() {
  setopt localoptions noxtrace
  local name="$1"
  if [[ "$OSTYPE" == darwin* ]]; then
    security find-generic-password -a "$USER" -s "$name" -w 2>/dev/null
    return
  fi
  local file="$SECRET_STORE_DIR/$name.cred"
  [[ -f "$file" && -r "$file" ]] || return 1
  systemd-creds decrypt --user --name="$name" "$file" - 2>/dev/null
}

# _secret_backend_delete <NAME> — non-zero if it wasn't cached.
_secret_backend_delete() {
  local name="$1"
  if [[ "$OSTYPE" == darwin* ]]; then
    security delete-generic-password -a "$USER" -s "$name" >/dev/null 2>&1
    return
  fi
  [[ -f "$SECRET_STORE_DIR/$name.cred" ]] && rm -f "$SECRET_STORE_DIR/$name.cred"
}

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
#   in the backend (Keychain or $SECRET_STORE_DIR), and add <NAME> to the index.
secret_store() {
  setopt localoptions noxtrace
  local name="$1"
  if [[ -z "$name" ]]; then
    echo "usage: secret_store <NAME>" >&2
    return 2
  fi
  if ! _secret_valid_name "$name"; then
    echo "secret_store: '$name' is not a valid env var name" >&2
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
  if _secret_backend_write "$name" "$value"; then
    _secret_index_add "$name"
    echo "secret_store: stored $name in $_SECRET_BACKEND_NAME"
  else
    echo "secret_store: failed to write $name to $_SECRET_BACKEND_NAME" >&2
    return 1
  fi
}

# secret_store_all
#   Fetch every populated field on the configured 1Password item and cache
#   each value in the backend. Use to bootstrap a new machine or refresh.
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
  if ! _secret_valid_name "$1"; then
    echo "secret_delete: '$1' is not a valid env var name" >&2
    return 2
  fi
  if _secret_backend_delete "$1"; then
    _secret_index_remove "$1"
    echo "secret_delete: removed $1"
  else
    _secret_index_remove "$1"
    echo "secret_delete: $1 not found"
  fi
}

# secret_load <NAME>
#   Read cached secret <NAME> from the backend and export it as $NAME.
#   Silent on miss so shell startup never blocks or prints noise.
secret_load() {
  # noxtrace: under `set -x` the expansions below print every secret in full,
  # so tracing the shell would write live credentials into the trace log.
  # localoptions scopes this to the function body.
  setopt localoptions noxtrace
  local name="$1"
  _secret_valid_name "$name" || return 0
  local value
  value=$(_secret_backend_read "$name") || return 0
  [[ -n "$value" ]] && export "$name=$value"
}

# secret_alias <NEW_NAME> <EXISTING_NAME>
#   Export <NEW_NAME> with the value of <EXISTING_NAME>. Takes names rather
#   than a value so the secret never appears at the call site, where `set -x`
#   would print it.
secret_alias() {
  setopt localoptions noxtrace
  local dest="$1" src="$2"
  [[ -n "$dest" && -n "$src" ]] || return 0
  [[ -n "${(P)src}" ]] && export "$dest=${(P)src}"
}

# Auto-load every secret named in the index.
if [[ -f "$SECRET_STORE_INDEX" ]]; then
  while IFS= read -r _name; do
    [[ -n "$_name" ]] && secret_load "$_name"
  done < "$SECRET_STORE_INDEX"
  unset _name
fi
