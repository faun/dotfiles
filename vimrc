" ==========================================
" Basic settings:

syntax on

" ==========================================
" Vim-plug

" Define orange for nvim
hi def Orange ctermfg=202 guifg=#ff5f00

call plug#begin('~/.vim/plugged')
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

if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
end

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
