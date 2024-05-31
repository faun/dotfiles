#!/usr/bin/env bash

set -e
shopt -s extglob

cd "$(dirname "$0")" || exit 1
DIR="$(pwd)"

if [[ -n $DEBUG ]]; then
	set -x
fi

for file in "${DIR:?}"/install/*; do
	if [[ -x "$file" ]]; then
		"$file"
	fi
done

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
