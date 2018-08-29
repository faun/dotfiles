autocmd! BufEnter,BufWritePost * silent! Neomake
autocmd! InsertChange,TextChanged * silent! update | Neomake
let g:neomake_verbose=0

nmap <Leader>o :lopen<CR>      " open location window
nmap <Leader>c :lclose<CR>     " close location window
nmap <Leader>, :ll<CR>         " go to current error/warning
nmap <Leader>n :lnext<CR>      " next error/warning
nmap <Leader>p :lprev<CR>      " previous error/warning
