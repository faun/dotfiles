" ==========================================
" Basic settings:

syntax on
set nocompatible
set ttyfast
set lazyredraw

" ==========================================
" Vim-plug

call plug#begin('~/.vim/plugged')
let g:polyglot_disabled = ['go']
source $HOME/.bundles.vim
if filereadable(expand("$HOME/.bundles.local.vim"))
  source $HOME/.bundles.local.vim
endif
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
Plug 'thinca/vim-localrc'
call plug#end()

" ==========================================

" Load all of the vim files in ~/.vim/custom
for g:file in split(glob('$HOME/.vim/custom/*.vim'), '\n')
  exe 'source' g:file
endfor

" ==========================================
" Colors

try
  colorscheme base16-twilight
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry

" ==========================================
" Custom Vimrc

" Load a custom vimrc file if it exist
if filereadable(expand('$HOME/.vimrc.local'))
  source $HOME/.vimrc.local
endif

" ==========================================
" Remapped keys:

" Quickly quit without saving with QQ
nmap QQ :q!<cr>

if &diff
  " In diff mode, close diff with Q

  nmap <CR> :qa!<cr>
  " And quit the diff with QQ
  nmap QQ :cq!<cr>
endif

" Force save files that require root permission
cmap w!! %!sudo tee > /dev/null %

" Make the dot command work with visual mode
vnoremap . :norm.<CR>

" Edit or view files in same directory as current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Auto-indent the whole file with ===
nmap === mzgg=G`z

" Get off my lawn
" nnoremap <Left> :echoe "Use h"<CR>
" nnoremap <Right> :echoe "Use l"<CR>
" nnoremap <Up> :echoe "Use k"<CR>
" nnoremap <Down> :echoe "Use j"<CR>

" Redraw the screen with F1
nmap <F1> :redraw!<CR>

" Open help documents in a new tab
:cabbrev help tab help

" Reload vimrc with leader-r-v
nnoremap <leader>rv :source $MYVIMRC<CR>

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
