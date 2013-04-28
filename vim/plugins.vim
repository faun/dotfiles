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

map <leader>gv :CtrlP app/views<cr>
map <leader>gc :CtrlP app/controllers<cr>
map <leader>gm :CtrlP app/models<cr>
map <leader>gh :CtrlP app/helpers<cr>
map <leader>gg :CtrlP app/assets/javascripts/<cr>
map <leader>ggv :CtrlP app/assets/javascripts/views<cr>
map <leader>ggc :CtrlP app/assets/javascripts/controllers<cr>
map <leader>ggm :CtrlP app/assets/javascripts/models<cr>
map <leader>ggt :CtrlP app/assets/javascripts/templates<cr>
map <leader>gs :CtrlP app/assets/stylesheets<cr>
map <leader>gl :CtrlP lib<cr>
map <leader>gp :CtrlP public<cr>
map <leader>gf :CtrlP features<cr>

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
