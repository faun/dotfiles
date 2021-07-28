#!/usr/bin/env bash

set -eou pipefail

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
mkdir -p "${XDG_CONFIG_HOME}"

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

vim +PlugInstall +PlugUpdate +PlugClean +qall
