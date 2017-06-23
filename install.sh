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
    if [[ "$file" == "$1" ]]
    then
      return 1
    else
      return 0
    fi
  done
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

  should_link=$(shouldLinkFile "$name"; echo $?)

  if [[ $should_link == 0 ]]
  then
    if [[ -L "$target" ]]
    then
      rm "$target"
    fi
    if [[ ! -e "$target" ]]
    then
      echo "Linking $name => $target"
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

repos_to_clone=(
https://github.com/chriskempson/base16-shell.git
https://github.com/zsh-users/antigen.git
)

pushd "$HOME/.config"
for repo in $repos_to_clone
do
  git clone "$repo" || echo "Failed to clone repo"
done
popd

mkdir -p "$HOME/.local/share/nvim/"
mkdir -p "$HOME/.nvim/tmpfiles"
mkdir -p "$HOME/.vim/spell"
touch "$HOME/.vim/spell/en.utf-8.add"

if ! brew ls --versions | awk '{ print $1 }' | grep 'yarn$' > /dev/null
then
  brew install yarn
fi

yarn config set prefix /usr/local
npm_packages=(
diff-so-fancy
tern
csslint
stylelint
prettier
eslint
babel-eslint
eslint-plugin-react
)

for package in "${npm_packages[@]}"
do
  echo "Installing package: $package"
  yarn global add "$package" --silent --no-progress --no-emoji 2> /dev/null
done

rubygems_packages=(neovim scss_lint)
for gem in "${rubygems_packages[@]}"
do
  echo "Installing gem: $gem"
  rvm "@global do gem install $gem" 2> /dev/null || gem install "$gem"
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

echo "Updating remote plugins"
nvim +UpdateRemotePlugins +qa

if [[ -z $SKIP_HEALTH_CHECK ]]
then
  nvim +CheckHealth
  echo export SKIP_HEALTH_CHECK=true >> ~/.local.sh
  export SKIP_HEALTH_CHECK=true
fi
