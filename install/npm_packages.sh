#!/usr/bin/env bash
set -eou pipefail


cd "$(dirname "$0")" || exit 1
# DIR="$(pwd)"

if ! command -v yarn >/dev/null; then
  npm install -g yarn
fi

npm_packages=(
  diff-so-fancy
  tern
  csslint
  stylelint
  prettier
  eslint
  eslint-plugin-prettier
  eslint-config-prettier
  babel-eslint
  eslint-plugin-react
  nginxbeautifier
  strip-ansi-cli
)

for package in "${npm_packages[@]}"; do
  echo "Installing package: $package"
  yarn global add "$package" --silent --no-progress --no-emoji 2>/dev/null || true
done
