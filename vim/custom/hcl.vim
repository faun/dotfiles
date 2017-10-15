" au BufNewFile,BufRead *.rb,*.rbw,*.gemspec set filetype=hcl
autocmd FileType terraform,hcl,nomad setlocal commentstring=#\ %s

augroup fmt
  autocmd!
  autocmd BufWritePre *.tf Neoformat
augroup END
