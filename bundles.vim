" Syntax and Languages
Bundle 'astashov/vim-ruby-debugger'
Bundle 'elzr/vim-json'
Bundle 'othree/html5.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'othree/javascript-libraries-syntax.vim'
Bundle 'slim-template/vim-slim'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-rake'
Bundle 'vim-coffee-script'
Bundle 'vim-ember-script'
Bundle 'vim-javascript'
Bundle 'vim-ruby/vim-ruby'
Bundle 'vim-scripts/matchit.zip'
Bundle 'tejr/vim-tmux'

"Interface improvements
Bundle 'Lokaltog/vim-powerline'
Bundle 'altercation/vim-colors-solarized'

"Usability improvements
Bundle 'L9'
Bundle 'godlygeek/tabular'
Bundle 'kien/ctrlp.vim'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'sjl/gundo.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-ragtag'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'christoomey/vim-tmux-navigator'

" Custom text-objects
Bundle 'ecomba/vim-ruby-refactoring'
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'jgdavey/vim-blockle'
Bundle 'michaeljsmith/vim-indent-object'

"Local vim config
Bundle 'AfterColors.vim'
Bundle 'ggilder/localvimrc'

" Search improvements
Bundle 'IndexedSearch'
Bundle 'greplace.vim'
Bundle 'mileszs/ack.vim'
Bundle 'rking/ag.vim'
Bundle 'tpope/vim-abolish'

"Testing tools
Bundle 'jgdavey/vim-turbux'
Bundle 'skalnik/vim-vroom'
Bundle 'benmills/vimux'
Bundle 'jingweno/vimux-zeus'

" Add custom Vundle plugins in ~/.bundles.local.vim
if filereadable(expand("$HOME/.bundles.local.vim"))
  source $HOME/.bundles.local.vim
endif
