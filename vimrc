" ==========================================
" Basic settings
" {{{

syntax on
set nocompatible
set ttyfast
set lazyredraw

" Use spacebar as leader key
let mapleader = "\<Space>"

" Use the system clipboard by default
set clipboard=unnamed

" Explicitly set the shell to bash
set shell=/bin/bash

" }}}

" Tell ALE not to display LSP diagnostics or completion
let g:ale_disable_lsp = 1

" ==========================================
" Vim-plug
"  {{{

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

"  }}}
"
" ==========================================
" Custom file loading
" {{{

" Load all of the vim files in ~/.vim/custom
for g:file in split(glob('$HOME/.vim/custom/*.vim'), '\n')
  exe 'source' g:file
endfor

"  }}}
"
" ==========================================
" Remapped keys
" {{{

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

" Get off my lawn
" nnoremap <Left> :echoe "Use h"<CR>
" nnoremap <Right> :echoe "Use l"<CR>
" nnoremap <Up> :echoe "Use k"<CR>
" nnoremap <Down> :echoe "Use j"<CR>

" Redraw the screen with F1
nmap <F1> :redraw!<CR>
"

" Reload vimrc with leader-r-v
nnoremap <leader>rv :source $MYVIMRC<CR>
"
" }}}

" ==========================================
" Help documents
" {{{

" Open help documents in a new tab
:cabbrev help tab help

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall

" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

" }}}

" ==========================================
" Interface changes
" {{{

" Hide the vim splash screen
set shortmess+=I

" Set terminal title bar
set title

" Use hidden buffers
set hidden

" Don't wrap lines
set nowrap

" Let cursor keys wrap around lines
set whichwrap+=<,>,h,l,[,]

" Always show line numbers
set number

" Highlight right gutter at 80 characters
set colorcolumn=80

" Highlight the current cursor line
set cursorline

" Set show matching parenthesis
set showmatch

" Remove the noise in the vertical divider between splits
:set fillchars+=vert:\

" Limit completion popup menu height
set pumheight =15
"
" Set - as keyword so that ctags work correctly with dashed-method-names
set isk+=-

" Set : as keyword so that ctags work correctly with ruby namespaced classes
" set isk+=:

" Don't show invisible characters by default
set nolist

" Set two spaces by default
set ts=2 sts=2 sw=2 expandtab

" Copy the previous indentation on autoindenting
set copyindent

" Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround

" }}}

" ==========================================
" Code folding
" {{{
"
" Fold based on indent
set foldmethod=indent

" Set the deepest fold is 10 levels
set foldnestmax=10

" Don't fold code by default
set nofoldenable

" }}}

" ==========================================
" Tab settings
" {{{
" Quickly switch tab settings
" http://vimcasts.org/episodes/tabs-and-spaces/

" :help tabstop
" :help softtabstop
" :help shiftwidth
" :help expandtab

" To invoke this command, go into normal mode (by pressing escape) then run:

" :Stab

" Then hit enter. You will see this:

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction
" }}}

" ==========================================
" Colorscheme settings
" {{{

let g:base16colorspace=256

try
  colorscheme base16-twilight
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
endtry

" }}}

" ==========================================
" Tab navigation
" {{{

map <leader>tn :tabnew<CR>
map <leader>to :tabonly<CR>
map <leader>tc :tabclose<CR>
map <leader>tm :tabmove
map <leader>te :tabedit <c-r>=expand("%:p:h")<CR>/

" nnoremap <C-t> :tabnew<CR>
nnoremap <A-left> <Esc>:tabprevious<CR>
nnoremap <A-right> <Esc>:tabnext<CR>
nnoremap <A-down> <Esc>:tabnew<CR>

" }}}

" ==========================================
" Create missing directory before writing buffer
"  {{{
augroup Mkdir
  autocmd!
  autocmd BufWritePre *
        \ if !isdirectory(expand("<afile>:p:h")) |
        \ call mkdir(expand("<afile>:p:h"), "p") |
        \ endif
augroup END
"  }}}

" ==========================================
" Local vimrc_local settings
" {{{
augroup AutoLocalVimrc
  if exists('##VimSuspend')
    autocmd! FocusGained,BufEnter,WinEnter,VimResume * :silent! so .vimrc_local.vim
  else
    autocmd! FocusGained,BufEnter,WinEnter * :silent! so .vimrc_local.vim
  end
augroup END
" }}}
"
" ==========================================
" Whitespace settings
" {{{

function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction

" hide tab and space characters by default
set nolist listchars=tab:» ,nbsp:•,trail:·,extends:»,precedes:«

" Toggle invisible characters with leader-tab
nmap <silent> <leader><tab> :set nolist!<CR>

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=lightgrey guibg=lightgrey ctermfg=red guifg=lightred
match ExtraWhitespace /\s\+$/

" Remove trailing whitespace with F3
map <silent> <F3> :call TrimWhiteSpace()<CR>``
" }}}

" ==========================================
" Search
" {{{

" Ignore case if search pattern is all lowercase, case-sensitive otherwise
set smartcase

" Ignore case when searching
set ignorecase

" Highlight search terms
set hlsearch

" Show search matches as you type
set incsearch

" Search in project/directory

" Search current word in project/directory
" With or without word boundaries
function! SearchInProject()
  let word = expand("<cword>")
  let @/=word
  set hls
  exec "Ag " . word
endfunction

function! SearchWordInProject()
  let word = expand("<cword>")
  let @/='\<' . word . '\>'
  set hls
  exec "Ag '\\b" . word . "\\b'"
endfunction

if executable('ag')
  " Note we extract the column as well as the file and line number
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c%m
  let g:ackprg = 'ag --vimgrep'
endif

" Initiate search with <leader><space>
nnoremap <leader><space> :Ag<Space>

" Press leader-/ to toggle highlighting on/off, and show current value.
nnoremap <leader>/ :set hlsearch! hlsearch?<CR>

nnoremap <leader>* :call SearchInProject()<CR>
nnoremap <C-*>:call SearchWordInProject()<CR>
nnoremap <leader>' mb"+ya':Ag <C-r>"<CR>
nnoremap <leader>" mb"+ya":Ag <C-r>"<CR>
" }}}

" ==========================================
" Window split key bindings
"  {{{
" See http://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/

" window
nmap \<left>  :topleft  vnew<CR>
nmap \<right> :botright vnew<CR>
nmap \<up>    :topleft  new<CR>
nmap \<down>  :botright new<CR>

" buffer
nmap <leader><left>   :leftabove  vnew<CR>
nmap <leader><right>  :rightbelow vnew<CR>
nmap <leader><up>     :leftabove  new<CR>
nmap <leader><down>   :rightbelow new<CR>

" new window splits gain focus
nnoremap <C-w>s <C-w>s<C-w>w
nnoremap <C-w>v <C-w>v<C-w>w

nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
"  }}}

" ==========================================
" Undo
" {{{

set undodir=~/.config/vim_undo
set undofile

" }}}
"
" ==========================================
" Ctags
" {{{

noremap <leader>pt :!ctags -V --languages=ruby -f .gems.tags `gem env gemdir` && ctags -f .tags -RV . <cr>

set tags=tags,./tags,./.tags,./.gems.tags

" }}}

" ==========================================
" Custom Vimrc
" {{{

" Load a custom vimrc file if it exist
if filereadable(expand('$HOME/.vimrc.local'))
  source $HOME/.vimrc.local
endif
" }}}

" vim:ft=vim fdm=marker foldenable
