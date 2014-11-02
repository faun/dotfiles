" ==========================================
" Basic settings:

set nocompatible
let mapleader = "\\"
" remap ',' as a leader key as well
:nmap , \

" ==========================================
" Vundle Settings

filetype off "required for Vundle

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

source $HOME/.bundles.vim

filetype plugin indent on "required for Vundle

" ==========================================
" Vim settings:
source $HOME/.vim/config.vim
source $HOME/.vim/plugins.vim
source $HOME/.vim/functions.vim

if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

