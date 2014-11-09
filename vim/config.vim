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
" don't wrap lines
set nowrap
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" always show line numbers
set number
set encoding=utf-8
" let cursor keys wrap around lines
set whichwrap+=<,>,h,l,[,]
" always set autoindenting on
set autoindent
" copy the previous indentation on autoindenting
set copyindent
" use multiple of shiftwidth when indenting with '<' and '>'
set shiftround
" set show matching parenthesis
set showmatch
" insert tabs on the start of a line according to
set smarttab
" shiftwidth, not tabstop
" When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again.
set autoread
" ignore case if search pattern is all lowercase,
" case-sensitive otherwise
set smartcase
" ignore case when searching
set ignorecase
" highlight search terms
set hlsearch
" show search matches as you type
set incsearch
" Use Ack instead of grep
set grepprg=ack
" Highlight right gutter at 8o characters
set colorcolumn=80
" highlight the current cursor line
set cursorline
" Press Space to toggle highlighting on/off, and show current value.
nnoremap <Space> :set hlsearch! hlsearch?<CR>

" ==========================================
" File backups

" no backup files
set nobackup
" only in case you don't want a backup file while editing
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
 " no swap files
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
" ignore xcode files
set wildignore+=*.ipa,*.xcodeproj/*,*.xib,*.cer,*.icns
" ignore asset pipeline
set wildignore+=public/assets/*,public/stylesheets/compiled/*
" ignore vcr cassettes
set wildignore+=spec/vcr/*
" ignore bundler files
set wildignore+=bundler_stubs/*
set wildignore+=bin/*
" Limit completion popup menu height
set pumheight =15

" ==========================================
" Code folding

"fold based on indent
set foldmethod=indent
"deepest fold is 10 levels
set foldnestmax=10
"dont fold by default
set nofoldenable        

" ==========================================
" Window split key bindings
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

" split prompts with directory pre-filled
map <leader>e :edit %%
map <leader>v :view %%
map <leader>s :split %%

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

" Auto-indent the whole file with ===
nmap === gg=G''

" ==========================================
" Tab settings

"set two spaces by default
set ts=2 sts=2 sw=2 expandtab 

" ==========================================
" Spelling settings

set spellfile=~/.vim/spell/en.utf-8.add

" ==========================================
" File settings

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
  " Promote variable to RSpec let

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

  " Javascript
  autocmd Filetype javascript setlocal et ts=2 sts=2 sw=2
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

  " HTML
  autocmd Filetype html setlocal et ts=2 sts=2 sw=2
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

  " CSS
  autocmd Filetype css setlocal et ts=2 sts=2 sw=2
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS

  " PHP
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP

  " XML
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

  " Gitconfig
  au BufNewFile,BufRead gitconfig,gitconfig.local set filetype=gitconfig
  autocmd FileType gitconfig setlocal noet

  " Tmux
  au BufNewFile,BufRead .tmux.local,.tmux.conf,tmux.conf set filetype=tmux

  " RSpec
  autocmd BufNewFile,BufRead *_spec.rb set filetype=ruby.rails.rspec
  autocmd BufNewFile,BufRead *.js.coffee.erb set filetype=eruby.coffee
  autocmd BufNewFile,BufRead *_spec.rb compiler rspec

  " Handlebars
  au BufNewFile,BufRead *.handlebars,*.hbs set filetype=handlebars

  " Gemfile
  autocmd BufEnter Gemfile set ft=ruby.rails.bundler

  " Ruby
  autocmd FileType ruby set ft=ruby.rails
  autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
  autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 4

  " ==========================================
  " Keymap Definitions
  " ==========================================

  " CoffeeScript
  " Compile CoffeeScript to scratch buffer with leader-c
  vmap <leader>c <esc>:'<,'>:CoffeeCompile<CR>
  map <leader>c :CoffeeCompile<CR>

  " Jump to line in compiled JavaScript from CoffeScript source file
  command! -nargs=1 C CoffeeCompile | :<args>

  imap <C-l> <Space>=><Space>
  "Make hashrocket with control-l
  imap <C-K> <Space>-><CR>
  "coffeescript skinny arrow with control-l-l

  imap <S-CR>    <CR><CR>end<Esc>-cc

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
