" ==========================================
" Basic settings:

set nocompatible
let mapleader = "\\"

" ==========================================
" Vundle Settings

filetype off "required for Vundle

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

source $HOME/.bundles.vim

" Add custom Vundle plugins in ~/.vundle.local
if filereadable(expand("$HOME/.vundle.local"))
  source $HOME/.vundle.local
endif

filetype plugin indent on "required for Vundle

" ==========================================
" Vim settings:
source $HOME/.vim/config.vim
source $HOME/.vim/plugins.vim
source $HOME/.vim/functions.vim

if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

