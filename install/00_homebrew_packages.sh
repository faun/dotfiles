#!/usr/bin/env bash

set -e

if command -v brew >/dev/null 2>&1; then

  homebrew_dependencies=(
    bat
    clang-format
    direnv
    fd
    fish
    flake8
    fzf
    git-delta
    gnu-sed
    hashicorp/tap/terraform-ls
    jesseduffield/lazygit/lazygit
    jsonlint
    lndir
    lua
    lua-language-server
    luarocks
    mas
    neovim
    pyenv-virtualenv
    ripgrep
    rubyfmt
    shfmt
    terraform
    the_silver_searcher
    tmux
    tree
    tree-sitter
    universal-ctags
    vale
    watchman
    wget
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
else
  echo "Homebrew not found, skipping Homebrew package installation"
fi
