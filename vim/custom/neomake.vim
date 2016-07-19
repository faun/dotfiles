autocmd! BufWritePost * Neomake
autocmd! InsertChange,TextChanged * update | Neomake
