#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")" || exit 1
cd .. || exit 1
DIR="$(pwd)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
mkdir -p "${XDG_CONFIG_HOME}"

excludes=(
  README.md
  LICENSE
  fonts
  install.sh
  install
  mac_os_defaults
)

shouldLinkFile() {
  for file in "${excludes[@]}"; do
    if [[ "$file" == "$1" ]]; then
      return 1
    fi
  done
  return 0
}

for name in *; do
  target="$HOME/.$name"

  if [[ "$name" == "default-gems" ]]; then
    target="$HOME/.rbenv/$name"
  fi

  if [[ "$name" == "init.vim" ]]; then
    mkdir -p "${XDG_CONFIG_HOME}/nvim"
    target="${XDG_CONFIG_HOME}/nvim/init.vim"
  fi

  if [[ "$name" == "init.vim" ]]; then
    target="${XDG_CONFIG_HOME}/nvim/init.vim"
  fi

  if [[ "$name" == "yamllint" ]]; then
    mkdir -p "$HOME/.config/yamllint/"
    target="$HOME/.config/yamllint/config"
  fi

  should_link=$(
    shouldLinkFile "$name"
    echo $?
  )

  if [[ $should_link == 0 ]]; then
    echo "Linking $target"
    if [[ -L "$target" ]]; then
      rm "$target"
    fi
    if [[ ! -e "$target" ]]; then
      echo "Linking $name => $target"
      ln -s "$DIR/$name" "$target"
    elif [[ -d "$target" || -f "$target" ]]; then
      echo "Skipping existing file $name"
      echo "Move $target out of the way and run again"
    else
      echo "Unknown file type: $target"
    fi
  else
    echo "Not linking $target"
  fi
done

nvimrc="$XDG_CONFIG_HOME/nvim"
