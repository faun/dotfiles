#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
# DIR="$(pwd)"

# Install python for Deoplete and Ultisnips
# https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim

if [[ -d "$HOME/.pyenv/plugins/python-build/../.." ]]; then
  echo "Updating python-build"
  cd "$HOME/.pyenv/plugins/python-build/../.." && git pull && cd -
fi

if command -v pip >/dev/null 2>&1; then
  pip install --upgrade pip
fi

if ! brew ls --versions | awk '{ print $1 }' | grep 'pyenv$' >/dev/null; then
  echo "Installing pyenv"
  brew install pyenv
fi

if ! brew ls --versions | awk '{ print $1 }' | grep 'readline' >/dev/null; then
  echo "Installing readline"
  brew install readline
fi

if ! brew ls --versions | awk '{ print $1 }' | grep 'xz' >/dev/null; then
  echo "Installing xz"
  brew install xz
fi

