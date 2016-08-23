if has("neovim")
  autocmd! BufWritePost * Neomake
  autocmd! InsertChange,TextChanged * update | Neomake
endif
