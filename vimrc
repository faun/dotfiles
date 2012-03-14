" ==========================================
" Basic settings:

set nocompatible
let mapleader = ","

" ==========================================
" Pathogen settings:

call pathogen#infect()
call pathogen#helptags()

" ==========================================
" Vim settings:

" Hide the vim splash screen
set shortmess+=I

syntax on
filetype plugin indent on
set hidden
set nowrap        " don't wrap lines
set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
if has('mouse')
  set mouse=a
endif

" Automatically open NERDTree if vim is invoked without a file
autocmd vimenter * if !argc() | NERDTree | endif

" ==========================================
" Color scheme settings:

set background=light
colorscheme solarized

" ==========================================
" Vimrc settings:

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Automatically reload vimrc when it's saved
au BufWritePost .vimrc so ~/.vimrc

" ==========================================
" Command shortcuts:

" Force save files that require root permission
cmap w!! %!sudo tee > /dev/null %

" ==========================================
" Filetype settings:

" Use two tabs stops for Ruby
autocmd FileType ruby setlocal ts=2

" Make Rspec files work with MakeGreen
autocmd BufNewFile,BufRead *_spec.rb compiler rspec


" ==========================================
" Smart Tab completion
" http://vim.wikia.com/wiki/VimTip102

function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

inoremap <tab> <c-r>=Smart_TabComplete()<CR>

" ==========================================
" Plugin settings:

" Powerline settings:
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs
let g:Powerline_symbols = 'fancy'

" RedGreen settings:
map <Leader>] <Plug>MakeGreen " change from <Leader>t to <Leader>]

" ==========================================
" Tab settings

set ts=2 sts=2 sw=2 expandtab "set two spaces by default

autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=4 sts=4 sw=4

" ==========================================
" Highlight trailing whitespace
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces

highlight ExtraWhitespace ctermbg=red guibg=red
augroup WhitespaceMatch
  " Remove ALL autocommands for the WhitespaceMatch group.
  autocmd!
  autocmd BufWinEnter * let w:whitespace_match_number =
        \ matchadd('ExtraWhitespace', '\s\+$')
  autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END
function! s:ToggleWhitespaceMatch(mode)
  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  if exists('w:whitespace_match_number')
    call matchdelete(w:whitespace_match_number)
    call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
  else
    " Something went wrong, try to be graceful.
    let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
  endif
endfunction

" ==========================================
