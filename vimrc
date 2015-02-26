" ==========================================
" Basic settings:

set nocompatible
let mapleader = "\<Space>"
syntax on

" ==========================================
" Vim-plug

call plug#begin('~/.vim/plugged')
source $HOME/.bundles.vim
if filereadable(expand("$HOME/.bundles.local.vim"))
  source $HOME/.bundles.local.vim
endif
call plug#end()

filetype plugin indent on
set encoding=utf-8

" ==========================================

" Load all of the vim files in ~/.vim/custom
for file in split(glob('$HOME/.vim/custom/*.vim'), '\n')
  exe 'source' file
endfor

" ==========================================
" Colors

let base16colorspace=256
set background=dark
colorscheme base16-tomorrow
hi NonText ctermfg=18

" ==========================================
" Custom Vimrc

" Load a custom vimrc file if it exist
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

" Use the system clipboard by default
set clipboard=unnamed

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
nmap === mzgg=G`z

" Make fat hashrocket with control-l
imap <C-l> <Space>=><Space>

" Make skinny hashrocket with control-k
imap <C-K> <Space>-><CR>


nnoremap <leader>w :call SearchInProject()<CR>
nnoremap <leader>W :call SearchWordInProject()<CR>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
