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

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Always show line numbers
set number

" Highlight right gutter at 80 characters
set colorcolumn=80

" Highlight the current cursor line
set cursorline

" When a file has been detected to have been changed outside of Vim
" and it has not been changed inside of Vim, automatically read it again.
set autoread

" Set show matching parenthesis
set showmatch

" Remove the noise in the vertical divider between splits
:set fillchars+=vert:\ 

" Limit completion popup menu height
set pumheight =15

" ==========================================
" Code folding

" Fold based on indent
set foldmethod=indent

" Set the deepest fold is 10 levels
set foldnestmax=10

" Don't fold code by default
set nofoldenable

" ==========================================
" Color scheme settings

set background=light
set t_Co=256
colorscheme solarized