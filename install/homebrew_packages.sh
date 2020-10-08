#!/usr/bin/env bash

set -e

homebrew_dependencies=(
  the_silver_searcher
  neovim
)

for brew_package in "${homebrew_dependencies[@]}"; do
  if ! brew ls --versions | awk '{ print $1 }' | grep "^$brew_package\$" >/dev/null; then
    echo "Installing package: $brew_package"
    brew install "$brew_package" 2>/dev/null || true
    status=$?
    if [[ status != 0 ]]; then
      echo "Package $brew_package failed to install!"
    fi
  else
    echo "Package $brew_package already installed"
  fi
done
