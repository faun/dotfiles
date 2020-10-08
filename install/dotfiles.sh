#!/usr/bin/env bash

set -e

cd "$(dirname "$0")" || exit 1
cd .. || exit 1
DIR="$(pwd)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"

excludes=(
  LICENSE
  fonts
  install.sh
  install
  mac_os_defaults
)

excluded_suffixes='@(sh|md)'
for suffix in "${excluded_suffixes[@]}"; do
  excludes+=(*.$suffix)
done

shouldLinkFile() {
  for file in "${excludes[@]}"; do
    if [[ "$file" == "$1" ]]; then
      return 1
    else
      return 0
    fi
  done
}

for name in *; do
  target="$HOME/.$name"

  if [[ "$name" == "default-gems" ]]; then
    target="$HOME/.rbenv/$name"
  fi

  if [[ "$name" == "nvim" ]]; then
    target="$HOME/.config/$name"
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
  fi
done

mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"

nvimrc="$XDG_CONFIG_HOME/nvim"
if [[ ! -e "$nvimrc" ]]; then
  echo "Linking nvim"
  ln -s "$HOME/.vim" "$nvimrc"
fi
