# macOS Keychain-backed env var loader, sourced by interactive zsh.
# Keep this file POSIX-clean inside an interactive shell — no `set -e` etc.
#
# Conventions:
#   - One 1Password item holds many fields, one per secret.
#   - Field label in 1Password == env var name == Keychain service name.
#   - Item is referenced only by UUID (vault UUID + item UUID).
#
# Required env vars (set in ~/.local.sh):
#   OP_SECRETS_VAULT  — vault UUID
#   OP_SECRETS_ITEM   — item UUID
#   OP_ACCOUNT        — 1Password account (e.g. gustohq.1password.com)

# macOS-only: relies on `security` (macOS Keychain CLI).
[[ "$OSTYPE" == darwin* ]] || return 0

# secret_store
#   Read all fields from the configured 1Password item and cache each value
#   in the macOS Keychain under service <FIELD_LABEL>. Run once per machine.
secret_store() {
  if [[ -z "${OP_SECRETS_VAULT:-}" || -z "${OP_SECRETS_ITEM:-}" ]]; then
    echo "secret_store: OP_SECRETS_VAULT and OP_SECRETS_ITEM must be set" >&2
    return 1
  fi
  local -a op_account_flag
  [[ -n "${OP_ACCOUNT:-}" ]] && op_account_flag=(--account "$OP_ACCOUNT")
  local op_err fields
  op_err=$(mktemp)
  if ! fields=$(op "${op_account_flag[@]}" item get "${OP_SECRETS_ITEM}" \
      --vault "${OP_SECRETS_VAULT}" --format json 2>"$op_err" \
      | jq -r '.fields[] | select(.value != null and .value != "") | [.label, .value] | @tsv'); then
    echo "secret_store: failed to read item from 1Password" >&2
    sed 's/^/  /' "$op_err" >&2
    rm -f "$op_err"
    return 1
  fi
  rm -f "$op_err"
  local rc=0
  while IFS=$'\t' read -r label value; do
    if security add-generic-password -U \
        -a "$USER" -s "$label" -w "$value" \
        -T /usr/bin/security >/dev/null 2>&1; then
      echo "secret_store: stored $label in Keychain"
    else
      echo "secret_store: failed to write $label to Keychain" >&2
      rc=1
    fi
  done <<< "$fields"
  return $rc
}

# secret_delete <NAME>
secret_delete() {
  if [[ -z "${1:-}" ]]; then
    echo "usage: secret_delete <NAME>" >&2
    return 2
  fi
  if security delete-generic-password -a "$USER" -s "$1" >/dev/null 2>&1; then
    echo "secret_delete: removed $1"
  else
    echo "secret_delete: $1 not found"
  fi
}

# secret_load <NAME>
#   Read cached secret <NAME> from the Keychain and export it as $NAME.
#   Silent on miss so shell startup never blocks or prints noise.
#   Run `secret_store <NAME>` once to populate.
secret_load() {
  local name="$1"
  local value
  value=$(security find-generic-password -a "$USER" -s "$name" -w 2>/dev/null) || return 0
  [[ -n "$value" ]] && export "$name=$value"
}

# --- Cached secrets (populate via `secret_store`) ---
secret_load HF_TOKEN
