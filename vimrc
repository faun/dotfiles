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

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Quickly quit without saving with QQ
nmap QQ :q!<cr>

" Execute a Ruby file with <leader> rr
map <leader>rr :w<CR>:!ruby %<CR>

" Force save files that require root permission
cmap w!! %!sudo tee > /dev/null %

" Make the dot command work with visual mode
:vnoremap . :norm.<CR>

" Edit or view files in same directory as current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Auto-indent the whole file with ===
nmap === gg=G''

" Make fat hashrocket with control-l
imap <C-l> <Space>=><Space>

" Make skinny hashrocket with control-k
imap <C-K> <Space>-><CR>

set encoding=utf-8

" Always set autoindenting on
set autoindent

" Copy the previous indentation on autoindenting
set copyindent

" Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround

" Insert tabs on the start of a line according to shiftwidth, not tabstop
set smarttab

" ==========================================
" Ctags

set tags=tags,.tags,gems.tags,.gems.tags
noremap <leader>pt :!ctags -V --languages=ruby -f .gems.tags `gem env gemdir` && ctags -f .tags -RV . <cr>
