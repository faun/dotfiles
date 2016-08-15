map <leader>tn :tabnew<CR>
map <leader>to :tabonly<CR>
map <leader>tc :tabclose<CR>
map <leader>tm :tabmove 
map <leader>te :tabedit <c-r>=expand("%:p:h")<CR>/

" nnoremap <C-t> :tabnew<CR>
nnoremap <A-left> <Esc>:tabprevious<CR>
nnoremap <A-right> <Esc>:tabnext<CR>
nnoremap <A-down> <Esc>:tabnew<CR>
