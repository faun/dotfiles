" ==========================================
" NERDTree settings

" Automatically close vim if the only window left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" toggle NERDTree with F6
map <silent> <F6> :NERDTreeToggle<CR>
let g:loaded_netrw = 1 " Disable netrw
let g:loaded_netrwPlugin = 1 " Disable netrw
let g:NERDTreeShowLineNumbers = 0
let g:NERDTreeMinimalUI = 1 " Disable help message
let g:NERDTreeDirArrows = 1

" ==========================================
" Control-P Settings
let g:ctrlp_working_path_mode = 'a'
map <leader>gv :CtrlP app/views<cr>
map <leader>gc :CtrlP app/controllers<cr>
map <leader>gm :CtrlP app/models<cr>
map <leader>gh :CtrlP app/helpers<cr>
map <leader>gg :CtrlP app/assets/javascripts/<cr>
map <leader>gjs :CtrlP spec/javascripts/<cr>
map <leader>gs :CtrlP app/assets/stylesheets<cr>
map <leader>gl :CtrlP lib<cr>
map <leader>gf :CtrlP features<cr>
map <leader>f :CtrlP<cr>
map <leader>F :CtrlP %%<cr>
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_height = 20

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" ==========================================
" Gundo Toggle settings

nnoremap <F5> :GundoToggle<CR>

" ==========================================
" Powerline settings:

set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs
let g:Powerline_symbols = 'fancy'

" ==========================================
" Taglist settings
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'

" ==========================================
" Ragtag settings

inoremap <M-o>       <Esc>o
inoremap <C-j>       <Down>
let g:ragtag_global_maps = 1

" ==========================================
" Syntastic settings
let g:syntastic_javascript_syntax_checker = "jshint"
let g:syntastic_coffee_coffeelint_args="--csv --file $HOME/.coffeelint.json"
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_check_on_open = 1

" =========================================
" Vim-Vroom Settings
let g:vroom_use_vimux = 1
let g:vroom_use_colors = 1

" =========================================
" Vim-Dispatch Settings
autocmd BufNewFile,BufRead *_spec.{js,js.coffee,coffee} let b:dispatch= 'COLOR=false rake teaspoon -q %'
autocmd BufNewFile,BufRead *_spec.rb compiler rspec

" =========================================
" Commentary Settings
"
autocmd FileType tmux set commentstring=#\ %s
autocmd FileType moon set commentstring=--\ %s

" =========================================
" Turbux + Vimux FTW
let g:turbux_runner  = 'vimux'

cnoreabbrev <expr> Gcommit ((getcmdtype() is# ':' && getcmdline() is# 'Gcommit')?('Gcommit -v'):('Gcommit'))
