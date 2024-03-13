#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
# DIR="$(pwd)"

if ! command -v yarn >/dev/null; then
	npm install -g yarn
fi

npm_packages=(
	babel-eslint
	bash-language-server
	csslint
	diagnostic-languageserver
	diff-so-fancy
	eslint
	eslint-config-prettier
	eslint-plugin-prettier
	eslint-plugin-react
	neovim
	nginxbeautifier
	prettier
	strip-ansi-cli
	stylelint
	tern
	vim-language-server
	vscode-langservers-extracted
	yaml-language-server
)

for package in "${npm_packages[@]}"; do
	echo "Installing package: $package"
	yarn global add "$package" --silent --no-progress --no-emoji 2>/dev/null || true
done
