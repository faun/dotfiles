syntax on
filetype plugin indent on

" ==========================================
" Viewport

" Hide the vim splash screen
set shortmess+=I

" Set terminal title bar
set title

" Use hidden buffers
set hidden

" Don't wrap lines
set nowrap

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Always show line numbers
set number
set encoding=utf-8

" Let cursor keys wrap around lines
set whichwrap+=<,>,h,l,[,]

" Always set autoindenting on
set autoindent

" Copy the previous indentation on autoindenting
set copyindent

" Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround

" Set show matching parenthesis
set showmatch

" Insert tabs on the start of a line according to shiftwidth, not tabstop
set smarttab

" When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again.
set autoread

" Ignore case if search pattern is all lowercase, case-sensitive otherwise
set smartcase

" Ignore case when searching
set ignorecase

" Highlight search terms
set hlsearch

" Show search matches as you type
set incsearch

" Use Ack instead of grep
set grepprg=ack

" Highlight right gutter at 80 characters
set colorcolumn=80

" Highlight the current cursor line
set cursorline

" Press Space to toggle highlighting on/off, and show current value.
nnoremap <Space> :set hlsearch! hlsearch?<CR>

" ==========================================
" File backups

" No backup files

set nobackup

" Only in case you don't want a backup file while editing
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" No swap files
set noswapfile

" ==========================================
" Wildmenu Settings

" Use wildmenu
set wildmenu

" Set completion style
set wildmode=longest,list,full

" Ignore images
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.ico

" Ignore PSDs
set wildignore+=*.psd

" Ignore PID files
set wildignore+=*.pid

" Ignore files in tmp
set wildignore+=*/tmp/*

" Ignore sqlite databases
set wildignore+=*.sqlite3

" Ignore xcode files
set wildignore+=*.ipa,*.xcodeproj/*,*.xib,*.cer,*.icns

" Ignore asset pipeline
set wildignore+=public/assets/*,public/stylesheets/compiled/*

" Ignore vcr cassettes
set wildignore+=spec/vcr/*

" Ignore bundler files
set wildignore+=bundler_stubs/*
set wildignore+=bin/*

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
" Ctags

set tags=tags,.tags,gems.tags,.gems.tags
noremap <leader>pt :!ctags -V --languages=ruby -f .gems.tags `gem env gemdir` && ctags -f .tags -RV . <cr>

" ==========================================
" Color scheme settings

set background=light
set t_Co=256
colorscheme solarized

" ==========================================
" Vimrc settings:

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" ==========================================
" Command shortcuts:

" Quickly quit without saving with QQ
nmap QQ :q!<cr>

" Save with leader-w
nmap <leader>w :update!<cr>
nmap <leader><leader> :update!<cr>

" Force save files that require root permission
cmap w!! %!sudo tee > /dev/null %

" Make the dot command work with visual mode
:vnoremap . :norm.<CR>

" Edit or view files in same directory as current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>

nnoremap <F2> :set invpaste paste?<CR>
nnoremap <leader>pm :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Auto-indent the whole file with ===
nmap === gg=G''

" ==========================================
" Tab settings

" Set two spaces by default
set ts=2 sts=2 sw=2 expandtab

" ==========================================
" Spelling settings

set spellfile=~/.vim/spell/en.utf-8.add

" ==========================================
" Filetype Definitions

" HTML
autocmd Filetype html setlocal et ts=2 sts=2 sw=2
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

" CSS
autocmd Filetype css setlocal et ts=2 sts=2 sw=2
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" PHP
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" ==========================================
" Keymap Definitions

imap <C-l> <Space>=><Space>

" Make hashrocket with control-l
imap <C-K> <Space>-><CR>

" Make CoffeeScript skinny arrow with control-l-l
imap <S-CR>    <CR><CR>end<Esc>-cc
