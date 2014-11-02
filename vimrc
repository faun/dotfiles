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

" Load all of the files in ~/.vim
for file in split(glob('$HOME/.vim/*.vim'), '\n')
    exe 'source' file
endfor

" Load a custom vimrc file if it exist
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
