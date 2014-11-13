" ==========================================
" NERDTree settings

" Automatically close vim if the only window left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Toggle NERDTree with F6
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

" =========================================
" Vim-Vroom Settings

let g:vroom_use_vimux = 1
let g:vroom_use_colors = 1

" =========================================
" Commentary Settings

autocmd FileType tmux set commentstring=#\ %s
autocmd FileType moon set commentstring=--\ %s
autocmd FileType puppet set commentstring=#\ %s
autocmd FileType dockerfile set commentstring=#\ %s

" =========================================
" Turbux + Vimux FTW

let g:turbux_runner  = 'vimux'
" Run the current file with rspec
map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>

" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>

" Close vim tmux runner opened by VimuxRunCommand
map <Leader>vq :VimuxCloseRunner<CR>

" Interrupt any command running in the runner pane
map <Leader>vx :VimuxInterruptRunner<CR>

" Zoom the runner pane (use <bind-key> z to restore runner pane)
map <Leader>vz :call VimuxZoomRunner()<CR>

" =========================================
" Fugitive Settings

" Map :Gcommit to Gcommit -v to get diffs with commit entry
cnoreabbrev <expr> Gcommit ((getcmdtype() is# ':' && getcmdline() is# 'Gcommit')?('Gcommit -v'):('Gcommit'))
cnoreabbrev <expr> Gap ((getcmdtype() is# ':' && getcmdline() is# 'Gap')?('Git add -p'):('Gap'))
cnoreabbrev <expr> Grh ((getcmdtype() is# ':' && getcmdline() is# 'Grh')?('Git reset head -p'):('Grh'))
cnoreabbrev <expr> Gco ((getcmdtype() is# ':' && getcmdline() is# 'Gco')?('Git checkout -p'):('Gco'))

" =========================================
" Switch Settings

nnoremap - :Switch<cr>

