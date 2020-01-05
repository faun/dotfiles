augroup shfmt
  autocmd!
  autocmd BufWritePre *.sh,*.zsh Neoformat
augroup END
