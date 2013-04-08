" ==========================================
" Basic settings:

set nocompatible
let mapleader = "\\"

" ==========================================
" Pathogen settings:

call pathogen#infect()
call pathogen#helptags()

" ==========================================
" Vim settings:
source $HOME/.vim/config.vim
source $HOME/.vim/plugins.vim
source $HOME/.vim/functions.vim

if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
