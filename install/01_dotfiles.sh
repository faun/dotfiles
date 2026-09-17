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
link_progress_count=0

link_dir_contents() {
  local source_dir="$1"
  local target_dir="$2"

  # Create target directory if it doesn't exist
  mkdir -p "$target_dir"

  # Process each item in source directory
  for item in "$source_dir"/*; do
    # Skip if glob didn't match anything
    [[ -e "$item" ]] || continue

    local basename="${item##*/}"
    local target_item="$target_dir/$basename"

    if [[ -d "$item" ]]; then
      # If target_item is a leftover directory-level symlink (e.g. from an
      # older install method that symlinked whole dirs), remove it first so
      # we get a real directory of per-file symlinks instead of recursing
      # into a symlink that points back at $item itself.
      if [[ -L "$target_item" ]]; then
        rm "$target_item"
      fi
      # Recursively handle subdirectories
      link_dir_contents "$item" "$target_item"
    else
      # Only re-link if target_item doesn't already resolve to $item.
      # `-ef` is a bash builtin (no forked subprocess), unlike comparing
      # against `readlink` output, so re-runs over large vendored trees
      # (e.g. vim/pack/vendor) skip thousands of already-correct files
      # without forking `ln` (or anything else) for them.
      if [[ ! "$target_item" -ef "$item" ]]; then
        ln -sf "$item" "$target_item"
      fi

      # Pre-increment: under `set -e`, a bare `((expr))` exits nonzero (and
      # aborts the script) if expr evaluates to 0, which post-increment
      # would do on the very first file.
      ((++link_progress_count))
      if (( link_progress_count % 250 == 0 )); then
        echo "  ...linked $link_progress_count files so far"
      fi
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
