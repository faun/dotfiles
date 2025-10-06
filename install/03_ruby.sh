#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1

eval "$(mise activate bash)"

# Install latest Ruby
latest_ruby_version=$(mise ls-remote ruby | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | tail -1)
echo "Installing Ruby ${latest_ruby_version:?}"
mise use --global "ruby@${latest_ruby_version:?}"

# Symlink default gems so mise can use them
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
if [[ -f "$DOTFILES_DIR/default-gems" ]]; then
  ln -sf "$DOTFILES_DIR/default-gems" "$HOME/.default-gems"
  echo "Linked default-gems for mise"
fi
