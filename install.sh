#!/usr/bin/env bash

set -e
shopt -s extglob

cd "$(dirname "$0")" || exit 1
DIR="$PWD"

if [[ -n $DEBUG ]]; then
	set -x
fi

for file in "${DIR:?}"/install/*; do
	if [[ -x "$file" ]]; then
		echo "Running $(basename "$file")"
	fi
done

for file in "${DIR:?}"/install/*; do
	if [[ -x "$file" ]]; then
		"$file"
		if [[ $? != 0 ]]; then
			echo "There was a problem running $file"
		fi
	fi
done

echo "Installing spelling dictionaries"
mkdir -p "$HOME/.local/share/nvim/"
mkdir -p "$HOME/.vim/spell"
touch "$HOME/.vim/spell/en.utf-8.add"
nvim -u .nvimtest +q

# -----------------------------------------------------------------------------

if [[ -z $SKIP_HEALTH_CHECK ]]; then
	nvim +CheckHealth
	echo export SKIP_HEALTH_CHECK=true >>~/.local.sh
	export SKIP_HEALTH_CHECK=true
fi

echo "Done."
