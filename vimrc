" ==========================================
" Basic settings:

set nocompatible
let mapleader = "\\"
" remap ',' as a leader key as well
nmap , \
syntax on

" ==========================================
" Vundle Settings

filetype off "required for Vundle

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

source $HOME/.bundles.vim

filetype plugin indent on
set encoding=utf-8

" ==========================================

" Load all of the vim files in ~/.vim/custom
for file in split(glob('$HOME/.vim/custom/*.vim'), '\n')
  exe 'source' file
endfor

" Load a custom vimrc file if it exist
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

" Remapped keys:

" Quickly quit without saving with QQ
nmap QQ :q!<cr>

" Execute a Ruby file with <leader> rr
map <leader>rr :w<CR>:!ruby %<CR>

" Force save files that require root permission
cmap w!! %!sudo tee > /dev/null %

" Make the dot command work with visual mode
vnoremap . :norm.<CR>

" Edit or view files in same directory as current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Auto-indent the whole file with ===
nmap === gg=G''

" Make fat hashrocket with control-l
imap <C-l> <Space>=><Space>

" Make skinny hashrocket with control-k
imap <C-K> <Space>-><CR>

nnoremap ./ :Ag<Space>

nnoremap <leader>w :call SearchInProject()<CR>
nnoremap <leader>W :call SearchWordInProject()<CR>
