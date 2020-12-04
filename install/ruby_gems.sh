#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
# DIR="$(pwd)"

rubygems_packages=(neovim scss_lint)
for gem in "${rubygems_packages[@]}"; do
  echo "Installing gem: $gem"
  rvm "@global do gem install $gem" 2>/dev/null || gem install "$gem"
done
