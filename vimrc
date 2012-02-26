let mapleader = ","
call pathogen#infect()
map <Leader>] <Plug>MakeGreen " change from <Leader>t to <Leader>]
syntax on
filetype plugin indent on

"Hide the vim splash screen
set shortmess+=I

"Force save files that require root permission
cmap w!! %!sudo tee > /dev/null %

"Automatically reload vimrc when it's saved
au BufWritePost .vimrc so ~/.vimrc

"Use two tabs stops for Ruby
autocmd FileType ruby setlocal ts=2

"Make Rspec files work with MakeGreen
"autocmd BufNewFile,BufRead *_spec.rb compiler rspec
