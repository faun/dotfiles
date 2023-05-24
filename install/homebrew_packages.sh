#!/usr/bin/env bash

set -e

homebrew_dependencies=(
  bat
  fasd
  fzf
  direnv
  hashicorp/tap/terraform-ls
  mas
  neovim
  pyenv-virtualenv
  shfmt
  the_silver_searcher
  tmux
  tree-sitter
  universal-ctags
  watchman
  yoheimuta/protolint/protolint
  zsh-autosuggestions
)

for brew_package in "${homebrew_dependencies[@]}"; do
	if ! brew ls --versions | awk '{ print $1 }' | grep "^$brew_package\$" >/dev/null; then
		echo "Installing package: $brew_package"
		set +e
		brew install "$brew_package" 2>/tmp/package_error
		status=$?
		set -e
		if [[ $status != 0 ]]; then
			echo "Package $brew_package failed to install!"
			echo ---
			cat /tmp/package_error
			echo ---
		fi
	else
		echo "Package $brew_package already installed"
	fi
done
