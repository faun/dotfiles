autocmd! BufEnter,BufWritePost * Neomake
autocmd! InsertChange,TextChanged * silent! update | Neomake
