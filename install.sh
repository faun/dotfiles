#!/usr/bin/env bash

set -e
shopt -s extglob

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

excludes=("LICENSE" "fonts")

excluded_suffixes='@(sh|md)'
for suffix in "${excluded_suffixes[@]}"
do
  excludes+=(*.$suffix)
done

shouldLinkFile () {
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
    if [[ -L "$target" ]]
    then
      rm "$target"
    fi
    if [[ ! -e "$target" ]]
    then
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

mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"

nvimrc="$XDG_CONFIG_HOME/nvim"
if [[ ! -e "$nvimrc" ]]
then
  echo "Linking nvim"
  ln -s "$HOME/.vim" "$nvimrc"
fi

mkdir -p "$HOME/.local/share/nvim/"
mkdir -p "$HOME/.nvim/tmpfiles"
mkdir -p "$HOME/.vim/spell"
touch "$HOME/.vim/spell/en.utf-8.add"

if ! brew ls --versions | awk '{ print $1 }' | grep 'yarn$' > /dev/null
then
  brew install yarn
fi

npm_packages=(diff-so-fancy tern)

for package in "${npm_packages[@]}"
do
  echo "Installing package: $package"
  npm install -g $package
done

rubygems_packages=(neovim)
for gem in "${rubygems_packages[@]}"
do
  echo "Installing gem: $gem"
  rvm "@global do gem install $gem"
done

# Install python for Deoplete and Ultisnips
# https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim

if ! brew ls --versions | awk '{ print $1 }' | grep 'python$' > /dev/null
then
  echo "Installing Python2"
    brew install python
fi

if ! command -v pip2 >/dev/null 2>&1
then
  pip install --upgrade pip setuptools
fi

echo "Installing neovim for Python2"
pip2 install --user --upgrade neovim

if ! grep "g:python_host_prog" "$HOME/.vimrc.local" > /dev/null
then
  echo "Adding Neovim configuration for Python2"
  echo "let g:python_host_prog = '$(which python2)'" >> "$HOME/.vimrc.local"
fi

if ! brew ls --versions | awk '{ print $1 }' | grep 'python3' > /dev/null
then
  echo "Installing Python3"
  brew install python3
fi

echo "Installing pip and neovim for Python3"
pip3 install --user --upgrade pip setuptools wheel neovim

if ! grep "g:python3_host_prog" "$HOME/.vimrc.local" > /dev/null
then
  echo "Adding Neovim configuration for Python3"
  echo "let g:python3_host_prog = '$(which python3)'" >> "$HOME/.vimrc.local"
fi

echo "Updating and installing vim plugins"

nvim +PlugInstall +qa
nvim +PlugUpdate +qa
nvim +PlugClean +qa

echo "Updating remote plugins for deoplete.vim"
nvim +UpdateRemotePlugins +qa

nvim +CheckHealth
