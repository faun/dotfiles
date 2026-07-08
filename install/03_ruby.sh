#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
source ./_common.sh

eval "$(mise activate bash)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  # Linux: install ruby-build's native build dependencies so mise can compile
  # Ruby from source. https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
  pm="$(detect_linux_package_manager)"

  if [[ -z "$pm" ]]; then
    echo "No supported package manager (apt-get/dnf/yum) found; skipping ruby build dependency installation"
  else
    case "$pm" in
      apt-get)
        build_deps=(autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline-dev zlib1g-dev libgmp-dev libncurses-dev libffi-dev libgdbm-dev libdb-dev uuid-dev)
        ;;
      dnf | yum)
        build_deps=(gcc gcc-c++ make patch autoconf libyaml-devel readline-devel zlib-devel gdbm-devel libffi-devel openssl-devel ncurses-devel)
        ;;
    esac

    for pkg in "${build_deps[@]}"; do
      linux_pkg_ensure "$pm" "$pkg"
    done
  fi
fi

# Install latest Ruby
latest_ruby_version=$(mise ls-remote ruby | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | tail -1)
echo "Installing Ruby ${latest_ruby_version:?}"
mise use --global "ruby@${latest_ruby_version:?}"

# Symlink default gems so mise can use them
DOTFILES_DIR="$(git rev-parse --show-toplevel)"
if [[ -f "$DOTFILES_DIR/default-gems" ]]; then
  ln -sf "$DOTFILES_DIR/default-gems" "$HOME/.default-gems"
  echo "Linked default-gems for mise"
fi
