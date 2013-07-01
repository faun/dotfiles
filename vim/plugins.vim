" ==========================================
" NERDTree settings

" Automatically close vim if the only window left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" toggle NERDTree with F6
map <silent> <F6> :NERDTreeToggle<CR>
let g:NERDTreeHijackNetrw = 0
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
" ==========================================
" Vim pasta settings

let g:pasta_disabled_filetypes = ['python', 'coffee', 'yaml', 'vim']

" ==========================================
" Gundo Toggle settings

nnoremap <F5> :GundoToggle<CR>

" ==========================================
" Powerline settings:

set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs
let g:Powerline_symbols = 'fancy'

" ==========================================
" RedGreen settings:
map <Leader>] <Plug>MakeGreen " change from <Leader>t to <Leader>]

" ==========================================
" Indent Guide Settings
" Show indent guides when editing common formats
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=darkgrey   ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgrey   ctermbg=237
autocmd FileType html,css,ruby,eruby,javascript,php,xml,coffee call indent_guides#enable()

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
let g:syntastic_javascript_syntax_checker="jshint"
let g:syntastic_auto_loc_list=1

" ==========================================
" SuperTab Settings

let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery = ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]
