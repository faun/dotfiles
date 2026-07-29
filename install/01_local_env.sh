#!/usr/bin/env bash
# Seed ~/.local.sh from local.sh.example on first setup. ~/.local.sh is
# machine-local and never tracked in dotfiles, so this only copies the
# example when no ~/.local.sh exists yet -- an existing file (real or from a
# prior run) is left untouched.

set -eou pipefail

cd "$(dirname "$0")" || exit 1
cd .. || exit 1
DIR="$(pwd)"

TARGET="${HOME:?}/.local.sh"
SOURCE="$DIR/local.sh.example"

if [[ -f "$TARGET" ]]; then
  echo "~/.local.sh already exists, leaving it alone"
else
  cp "$SOURCE" "$TARGET"
  echo "Seeded ~/.local.sh from local.sh.example"
fi
