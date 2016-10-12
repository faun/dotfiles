autocmd! BufEnter,BufWritePost * silent! Neomake
autocmd! InsertChange,TextChanged * silent! update | Neomake
let g:neomake_verbose=0
