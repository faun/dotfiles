" ==========================================
" Basic settings:

set nocompatible
let mapleader = "\\"
" remap ',' as a leader key as well
:nmap , \
syntax on

" ==========================================
" Vundle Settings

filetype off "required for Vundle

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

source $HOME/.bundles.vim

filetype plugin indent on

" ==========================================

" Load all of the vim files in ~/.vim/custom
for file in split(glob('$HOME/.vim/custom/*.vim'), '\n')
  exe 'source' file
endfor

" Load a custom vimrc file if it exist
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

" ==========================================
" Vimrc settings:

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
