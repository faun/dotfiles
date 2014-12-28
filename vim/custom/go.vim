let go_vim = system("echo -n `go env GOROOT`") . '/misc/vim'
if isdirectory(go_vim)
  " Clear filetype flags before changing runtimepath to force Vim to reload them.
  filetype off
  filetype plugin indent off
  execute "let &runtimepath.='," . go_vim . "'"
endif

" format go files on save
autocmd FileType go autocmd BufWritePre <buffer> Fmt
autocmd FileType go set sw=4 ts=4 noet
