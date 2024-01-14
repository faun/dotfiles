augroup terrform_ft
  au!
  autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
  autocmd BufRead,BufNewFile *.tf,*.tfvars :TSBufEnable highlight
augroup END
