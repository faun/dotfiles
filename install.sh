#!/usr/bin/env bash
set -e
shopt -s extglob

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

excludes=("Rakefile" "LICENSE" "fonts")

excluded_suffixes='@(sh|md)'
for suffix in ${excluded_suffixes[@]}
do
  excludes+=(*.$suffix)
done

shouldLinkFile () {
  local e
  for file in "${excludes[@]}"
  do
    [[ "$file" == "$1" ]] && return 1
  done
  return 0
}

for name in *
do
  target="$HOME/.$name"
  if [[ "$name" == "default-gems" ]]
  then
    target="$HOME/.rbenv/$name"
  fi
  if [[ "$name" == "nvim" ]]
  then
    target="$HOME/.config/$name"
  fi
  link=$(shouldLinkFile "$name"; echo $?)
  if [[ $link == 0 ]]
  then
    if [[ -L "$target" || ! -e "$target" ]]
    then
      rm "$target"
      echo "$target => $name"
      ln -s "$DIR/$name" "$target"
    elif [[ -d "$target" || -f "$target" ]]
    then
      echo "Skipping existing file $name"
      echo "Move $target out of the way and run again"
    else
      echo "Unknown file type: $target"
    fi
  fi
done
