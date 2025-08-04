#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")" || exit 1
cd .. || exit 1
DIR="$(pwd)"

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

verbose() {
  echo "$*"
  $*
}

# Recursively link directory contents (replacement for lndir)
link_dir_contents() {
  local source_dir="$1"
  local target_dir="$2"

  # Create target directory if it doesn't exist
  mkdir -p "$target_dir"

  # Process each item in source directory
  for item in "$source_dir"/*; do
    # Skip if glob didn't match anything
    [[ -e "$item" ]] || continue

    local basename="$(basename "$item")"
    local target_item="$target_dir/$basename"

    if [[ -d "$item" ]]; then
      # Recursively handle subdirectories
      link_dir_contents "$item" "$target_item"
    else
      # Create symbolic link for files
      ln -sf "$item" "$target_item"
    fi
  done
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
    if [[ -d "${source:?}" ]]; then
      link_dir_contents "${source:?}" "$target"
    else
      verbose ln -sf "${source:?}" "$target"
    fi
  else
    echo "Skipping ignored file ${source}"
  fi
}

for name in *; do
  source="${DIR:?}/${name:?}"
  target="$HOME/.$name"

  linkFile $name $source $target
done
