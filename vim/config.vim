syntax on
filetype plugin indent on

" ==========================================
" Viewport
set shortmess+=I                                           " Hide the vim splash screen
set title                                                  " Set terminal title bar
set hidden                                                 " Use hidden buffers
set nowrap                                                 " don't wrap lines
set backspace=indent,eol,start                             " allow backspacing over everything in insert mode
set number                                                 " always show line numbers
set encoding=utf-8
set whichwrap+=<,>,h,l,[,]                                 " let cursor keys wrap around lines
set autoindent                                             " always set autoindenting on
set copyindent                                             " copy the previous indentation on autoindenting
set shiftround                                             " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch                                              " set show matching parenthesis
set smarttab                                               " insert tabs on the start of a line according to
                                                           " shiftwidth, not tabstop

" When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again.
set autoread

set smartcase                                              " ignore case if search pattern is all lowercase,
                                                           " case-sensitive otherwise
set ignorecase                                             " ignore case when searching
set hlsearch                                               " highlight search terms
set incsearch                                              " show search matches as you type
set grepprg=ack                                            " Use Ack instead of grep
set colorcolumn=80                                         " Highlight right gutter at 8o characters
set cursorline                                             " highlight the current cursor line
nnoremap <Space> :set hlsearch! hlsearch?<CR>
                                                          " Press Space to toggle highlighting on/off, and show current value.
" ==========================================
" File backups
set nobackup                                        " no backup files
set nowritebackup                                   " only in case you don't want a backup file while editing
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set noswapfile                                      " no swap files

" ==========================================
" Wildmenu Settings
"
set wildmenu                                                   " Use wildmenu
set wildmode=longest,list,full                                 " Set completion style
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.ico                 " Ignore images
set wildignore+=*.psd                                          " Ignore PSDs
set wildignore+=*.pid                                          " Ignore PID files
set wildignore+=*/tmp/*                                        " Ignore files in tmp
set wildignore+=*.sqlite3                                      " Ignore sqlite databases
set wildignore+=*.ipa,*.xcodeproj/*,*.xib,*.cer,*.icns         " ignore xcode files
set wildignore+=public/assets/*,public/stylesheets/compiled/* " ignore asset pipeline
set wildignore+=spec/vcr/*                                     " ignore vcr cassettes
set wildignore+=bundler_stubs/*                                " ignore bundler files
set wildignore+=bin/*
set pumheight =15                                              " Limit completion popup menu height
" ==========================================
" Code folding
"
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default

" ==========================================
" Windows and Splits
nnoremap <leader>l <ESC>:vsp .<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" See http://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/
" window
nmap <leader>sw<left>  :topleft  vnew<CR>
nmap <leader>sw<right> :botright vnew<CR>
nmap <leader>sw<up>    :topleft  new<CR>
nmap <leader>sw<down>  :botright new<CR>
" buffer
nmap <leader>s<left>   :leftabove  vnew<CR>
nmap <leader>s<right>  :rightbelow vnew<CR>
nmap <leader>s<up>     :leftabove  new<CR>
nmap <leader>s<down>   :rightbelow new<CR>

map <leader>e :edit %%
map <leader>v :view %%
map <leader>s :split %%

" ==========================================
" Ctags

set tags=tags,.tags,gems.tags,.gems.tags
noremap <leader>pt :!ctags -V --languages=ruby -f .gems.tags `gem env gemdir` && ctags -f .tags -RV . <cr>

" ==========================================
" Color scheme settings:

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

"Save with leader-w
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

" ==========================================
" Tab settings

set ts=2 sts=2 sw=2 expandtab "set two spaces by default

" ==========================================
" Spelling settings
set spellfile=~/.vim/spell/en.utf-8.add

" ==========================================
" Tab settings

" ==========================================
" File settings:
function! TrimWhiteSpace()
  %s/\s\+$//e
:endfunction

"show tab and space characters
set list listchars=tab:» ,trail:·

" Toggle invisible characters with leader-tab
:nmap <silent> <leader><tab> :set nolist!<CR>

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=lightgrey guibg=lightgrey ctermfg=red guifg=lightred
match ExtraWhitespace /\s\+$/

" Remove trailing whitespace with F3
map <silent> <F3> :call TrimWhiteSpace()<CR>``

" ==========================================
" PROMOTE VARIABLE TO RSPEC LET
" ==========================================
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>


" ==========================================
" Filetype Definitions
" ==========================================
autocmd Filetype javascript setlocal et ts=2 sts=2 sw=2
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

autocmd Filetype html setlocal et ts=2 sts=2 sw=2
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

autocmd Filetype css setlocal et ts=2 sts=2 sw=2
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

au BufNewFile,BufRead .gitconfig.local set filetype=gitconfig
au BufNewFile,BufRead .tmux.local,.tmux.conf,tmux.conf set filetype=tmux
autocmd FileType gitconfig setlocal noet

autocmd BufNewFile,BufRead *_spec.rb, set filetype=ruby.rails.rspec
autocmd BufNewFile,BufRead *.js.coffee.erb, set filetype=eruby.coffee

au BufNewFile,BufRead *.handlebars,*.hbs set filetype=handlebars
autocmd BufEnter Gemfile set ft=ruby.rails.bundler
autocmd FileType ruby set ft=ruby.rails
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 4
imap <C-l> <Space>=><Space>
              "Make hashrocket with control-l
imap <C-K> <Space>-><CR>
              "coffeescript skinny arrow with control-l-l
map <F7> :wall<esc> :!rspec --color<CR>
imap <S-CR>    <CR><CR>end<Esc>-cc

" ==========================================
" Set proper filetype for spec files
"
autocmd BufNewFile,BufRead *_spec.rb compiler rspec

" ==========================================
" iTerm and screen/tmux settings

if has('mouse')
  set mouse=a
  if &term =~ "xterm" || &term =~ "screen"
    " for some reason, doing this directly with 'set ttymouse=xterm2'
    " doesn't work -- 'set ttymouse?' returns xterm2 but the mouse
    " makes tmux enter copy mode instead of selecting or scrolling
    " inside Vim -- but luckily, setting it up from within autocmds
    " works
    autocmd VimEnter * set ttymouse=xterm2
    autocmd FocusGained * set ttymouse=xterm2
    autocmd BufEnter * set ttymouse=xterm2
  endif
endif
set ttimeoutlen=50

if &term =~ "xterm" || &term =~ "screen"
  let g:CommandTCancelMap     = ['<ESC>', '<C-c>']
  let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<ESC>OA']
endif
