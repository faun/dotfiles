#!/usr/bin/env bash

set -e

cd "$(dirname "$0")" || exit 1
source ./_common.sh

if [[ "$(uname -s)" == "Darwin" ]]; then

  if command -v brew >/dev/null 2>&1; then

    homebrew_dependencies=(
      bat
      cmake
      fish
      fzf
      hashicorp/tap/terraform-ls
      herdr
      jesseduffield/lazygit/lazygit
      lua
      lua-language-server
      luarocks
      mas
      mise
      neovim
      ripgrep
      shfmt
      terraform
      the_silver_searcher
      tmux
      universal-ctags
      vale
      zellij
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

else
  # Linux: no Homebrew requirement here. Install the closest equivalents via
  # the native package manager instead. A handful of the macOS brew formulas
  # above (mise, zellij, herdr, terraform, terraform-ls, vale,
  # lua-language-server, mas) have no reliable apt/dnf/yum package across
  # distros; mise is
  # installed separately via its own official installer (see 02_mise.sh) and
  # the rest are skipped here and can be installed manually if needed.

  pm="$(detect_linux_package_manager)"

  if [[ -z "$pm" ]]; then
    echo "No supported package manager (apt-get/dnf/yum) found; skipping native package installation"
    exit 0
  fi

  if [[ "$pm" == apt-get ]]; then
    sudo apt-get update
  fi

  # logical name : apt-get package : dnf package : yum package
  # (empty field = no reliable package on that manager; skipped)
  linux_dependencies=(
    "bat:bat:bat:bat"
    "cmake:cmake:cmake:cmake"
    "fish:fish:fish:fish"
    "fzf:fzf:fzf:fzf"
    "lazygit:lazygit:lazygit:"
    "lua:lua5.4:lua:lua"
    "luarocks:luarocks:luarocks:luarocks"
    "neovim:neovim:neovim:neovim"
    "ripgrep:ripgrep:ripgrep:ripgrep"
    "shfmt:shfmt:shfmt:"
    "the_silver_searcher:silversearcher-ag:the_silver_searcher:the_silver_searcher"
    "tmux:tmux:tmux:tmux"
    "universal-ctags:universal-ctags:universal-ctags:universal-ctags"
  )

  case "$pm" in
    apt-get) field=2 ;;
    dnf) field=3 ;;
    yum) field=4 ;;
  esac

  for entry in "${linux_dependencies[@]}"; do
    IFS=: read -r logical_name apt_pkg dnf_pkg yum_pkg <<<"$entry"
    case "$field" in
      2) pkg="$apt_pkg" ;;
      3) pkg="$dnf_pkg" ;;
      4) pkg="$yum_pkg" ;;
    esac

    if [[ -z "$pkg" ]]; then
      echo "No $pm package for $logical_name; skipping"
      continue
    fi

    linux_pkg_ensure "$pm" "$pkg"
  done
fi
