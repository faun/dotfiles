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
" Command-T settings

" refresh command-t cache every time
map <leader>t :CommandTFlush<cr>\|:CommandT<cr>
map <leader>p :CommandTFlush<cr>\|:CommandT<cr>
nmap <C-P> :CommandTFlush<cr>\|:CommandT<cr>

" ==========================================
" Indent Guide Settings
" Show indent guides when editing common formats
autocmd FileType html,css,ruby,eruby,javascript,php,xml call indent_guides#enable()

" ==========================================
" Taglist settings
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'

" ==========================================
" UltiSnips settings
set runtimepath+=$HOME/.vim/snippets
let g:UltiSnipsSnippetDirectories= ["UltiSnips", "snippets"]

" ==========================================
" Ragtag settings

inoremap <M-o>       <Esc>o
inoremap <C-j>       <Down>
let g:ragtag_global_maps = 1
