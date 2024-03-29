#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
# DIR="$(pwd)"

rubygems_packages=(
	neovim
	ripper-tags
	erb-formatter
)
for gem in "${rubygems_packages[@]}"; do
	echo "Installing gem: $gem"
	rbenv each gem install "$gem" 2>/dev/null || gem install "$gem"
done
