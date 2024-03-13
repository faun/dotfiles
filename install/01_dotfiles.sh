#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")" || exit 1
cd .. || exit 1
DIR="$(pwd)"

if ! command -v lndir >/dev/null 2>&1; then
	echo "lndir is not installed"
  exit 1
fi


XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=${HOME}/.config}"
mkdir -p "${XDG_CONFIG_HOME}"

excludes=(
	LICENSE
	README.md
	fonts
	install.sh
	install_vim_plugged.sh
	mac_os_defaults
	optional
	setup
	setup.sh
)

for file in ./install/*; do
	excludes+=("$file")
done

shouldLinkFile() {
	for file in "${excludes[@]}"; do
		if [[ "$file" == "$1" ]]; then
			return 1
		fi
	done
	return 0
}

linkFile() {
	name=$1
	source=$2
	target=$3

	should_link=$(
		shouldLinkFile "$name"
		echo $?
	)

	if [[ $should_link == 0 ]]; then
		if [[ -L "$target" ]]; then
			rm "$target"
		fi
		echo "Linking $source => $target"
		if [[ -d "${source:?}" ]]
		then
      lndir "${source:?}" "$target"
    fi
    cp -asf "${source:?}" "$target"
	else
		echo "Skipping ignored file ${source}"
	fi
}

for name in *; do
	source="${DIR:?}/${name:?}"
	target="$HOME/.$name"

	linkFile $name $source $target
done
