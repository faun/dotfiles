#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
source ./_common.sh

# Install python for Deoplete and Ultisnips
# https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim

if [[ -d "$HOME/.pyenv/plugins/python-build/../.." ]]; then
  echo "Updating python-build"
  cd "$HOME/.pyenv/plugins/python-build/../.." && git pull && cd -
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
  if command -v brew >/dev/null 2>&1; then
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
  else
    echo "Homebrew not found, skipping pyenv/readline/xz installation"
  fi
else
  # Linux: no Homebrew requirement here. Install pyenv's build dependencies
  # via the native package manager and pyenv itself via its official
  # installer (https://github.com/pyenv/pyenv-installer), which needs no
  # Homebrew.
  pm="$(detect_linux_package_manager)"

  if [[ -z "$pm" ]]; then
    echo "No supported package manager (apt-get/dnf/yum) found; skipping pyenv build dependency installation"
  else
    # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
    case "$pm" in
      apt-get)
        build_deps=(build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev)
        ;;
      dnf | yum)
        build_deps=(gcc zlib-devel bzip2-devel readline-devel sqlite-devel openssl-devel tk-devel libffi-devel xz-devel)
        ;;
    esac

    for pkg in "${build_deps[@]}"; do
      linux_pkg_ensure "$pm" "$pkg"
    done
  fi

  if ! command -v pyenv >/dev/null 2>&1 && [[ ! -d "$HOME/.pyenv" ]]; then
    echo "Installing pyenv"
    curl -fsSL https://pyenv.run | bash
  fi
fi
