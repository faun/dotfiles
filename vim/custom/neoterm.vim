autocmd TermOpen * set bufhidden=delete

nnoremap <Leader>T :split <bar> terminal<CR>
let g:neoterm_autoscroll = '1'
let g:neoterm_automap_keys = '<leader>tt'
let g:neoterm_size = 16

command! -nargs=+ TT Topen | T <args>

vnoremap <Leader>2 :TREPLSendSelection<CR>
nnoremap <Leader>2 :TREPLSendLine<CR>
nnoremap <Leader>4 :Tmap
nnoremap <Leader>0 :Ttoggle<CR>
nnoremap <Leader>9 :Tclose<CR>
let g:neoterm_direct_open_repl=1

tnoremap <C-q> <C-\><C-n>:q<CR>
