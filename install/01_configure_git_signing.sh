#!/usr/bin/env bash
# Build the ssh allowed-signers file git needs to verify commit signatures.
#
# Without it git cannot even attempt verification: every signed commit reads as
# unsigned, and anything printing %G? (see gg in shrc/git.sh) errors once per
# commit. Keys come from GitHub rather than ~/.ssh so commits signed on another
# machine still verify here. Re-run after registering a new signing key:
#
#   ./install.sh --force 01_configure_git_signing

set -euo pipefail

# Hardcoded instead of XDG_CONFIG_HOME because config/git/config has to name
# this path literally: git config values cannot expand environment variables.
SIGNERS_FILE="${HOME:?}/.config/git/allowed_signers"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh is not installed; skipping allowed signers setup"
  exit 0
fi

email="$(git config --get user.email || true)"
github_user="$(git config --get github.user || true)"

if [[ -z $email ]] || [[ -z $github_user ]]; then
  echo "user.email and github.user must be set (see ~/.gitconfig.local); skipping allowed signers setup"
  exit 0
fi

tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile"' EXIT

# This endpoint is public, so it does not matter which account gh is
# authenticated as.
if ! gh api "/users/$github_user/ssh_signing_keys" --jq '.[].key' |
  awk -v email="$email" 'NF { printf "%s namespaces=\"git\" %s\n", email, $0 }' >"$tmpfile"; then
  echo "Could not fetch signing keys for $github_user; leaving $SIGNERS_FILE unchanged"
  exit 0
fi

if [[ ! -s $tmpfile ]]; then
  echo "No ssh signing keys registered for $github_user; leaving $SIGNERS_FILE unchanged"
  exit 0
fi

mkdir -p "$(dirname "$SIGNERS_FILE")"
mv "$tmpfile" "$SIGNERS_FILE"
chmod 644 "$SIGNERS_FILE"
echo "Wrote $(grep -c '' "$SIGNERS_FILE") signing keys to $SIGNERS_FILE"
