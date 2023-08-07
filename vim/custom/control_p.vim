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
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_height = 20

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
