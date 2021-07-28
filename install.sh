#!/usr/bin/env bash

set -e
shopt -s extglob

cd "$(dirname "$0")" || exit 1
DIR="$(pwd)"

if [[ -n $DEBUG ]]; then
  set -x
fi

# -----------------------------------------------------------------------------

"$DIR/install/homebrew.sh"

# -----------------------------------------------------------------------------

"$DIR/install/dotfiles.sh"

# -----------------------------------------------------------------------------

"$DIR/install/link_vendored_scripts.sh"

# -----------------------------------------------------------------------------

mkdir -p "$HOME/.local/share/nvim/"
mkdir -p "$HOME/.nvim/tmpfiles"
mkdir -p "$HOME/.vim/spell"
touch "$HOME/.vim/spell/en.utf-8.add"

# -----------------------------------------------------------------------------

# Install n from GitHub

N_PREFIX="${N_PREFIX:-$HOME/n}"
echo "N_PREFIX: $N_PREFIX"
if ! [[ -d "$N_PREFIX/n" ]]; then
  curl -sL https://git.io/n-install | bash -s -- -q -n
else
  export N_PREFIX
  "$N_PREFIX/bin/n-update" -y
fi

PATH=$PATH:$HOME/n/bin
export PATH

n install lts

# -----------------------------------------------------------------------------

"$DIR/install/homebrew_packages.sh"

# -----------------------------------------------------------------------------

"$DIR/install/homebrew_casks.sh"

# -----------------------------------------------------------------------------

"$DIR/install/npm_packages.sh"

# -----------------------------------------------------------------------------

"$DIR/install/ruby_gems.sh"

# -----------------------------------------------------------------------------

"$DIR/install/install_python.sh"

# -----------------------------------------------------------------------------

"$DIR/install/install_cargo.sh"

# -----------------------------------------------------------------------------

echo "Installing spelling dictionaries"
nvim -u .nvimtest +q

# -----------------------------------------------------------------------------

echo "Updating and installing vim plugins"

nvim +PlugInstall +qa
nvim +PlugUpdate +qa
nvim +PlugClean +qa

# -----------------------------------------------------------------------------

echo "Updating remote plugins"
nvim +UpdateRemotePlugins +qa

# -----------------------------------------------------------------------------

if [[ -z $SKIP_HEALTH_CHECK ]]; then
  nvim +CheckHealth
  echo export SKIP_HEALTH_CHECK=true >>~/.local.sh
  export SKIP_HEALTH_CHECK=true
fi

echo "Done."
