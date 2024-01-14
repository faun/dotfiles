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

"$DIR/install_vim_plugged.sh"

# -----------------------------------------------------------------------------

"$DIR/install/link_vendored_scripts.sh"

# -----------------------------------------------------------------------------

"$DIR/install/node_version_manager.sh"

# -----------------------------------------------------------------------------

"$DIR/install/homebrew_packages.sh"

# -----------------------------------------------------------------------------

"$DIR/install/homebrew_casks.sh"

# -----------------------------------------------------------------------------

"$DIR/install/npm_packages.sh"

# -----------------------------------------------------------------------------

"$DIR/install/ruby_gems.sh"

# -----------------------------------------------------------------------------

"$DIR/install/python2.sh"
"$DIR/install/python3.sh"

# -----------------------------------------------------------------------------

"$DIR/install/antigen.sh"

# -----------------------------------------------------------------------------
"$DIR/install/install_cargo.sh"

# -----------------------------------------------------------------------------

echo "Installing spelling dictionaries"
mkdir -p "$HOME/.local/share/nvim/"
mkdir -p "$HOME/.vim/spell"
touch "$HOME/.vim/spell/en.utf-8.add"
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
