" Hide the vim splash screen
set shortmess+=I

" Don't suppress error messages
set shortmess-=F

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

" ==========================================
" Code folding

" Fold based on indent
set foldmethod=indent

" Set the deepest fold is 10 levels
set foldnestmax=10

" Don't fold code by default
set nofoldenable

" Set - as keyword so that ctags work correctly with dashed-method-names
set isk+=-

" Set : as keyword so that ctags work correctly with ruby namespaced classes
" set isk+=:

" Don't show invisible characters by default
set nolist
