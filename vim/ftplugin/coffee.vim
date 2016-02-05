augroup coffeescript_autocmd
  autocmd!
  " Compile CoffeeScript to scratch buffer with leader-c
  vmap <leader>c <esc>:'<,'>:CoffeeCompile<CR>
  map <leader>c :CoffeeCompile<CR>

  " Jump to line in compiled JavaScript from CoffeScript source file
  command! -nargs=1 C CoffeeCompile | :<args>

  " Make fat hashrocket with control-l
  imap <C-l> <Space>=><Space>

  " Make skinny hashrocket with control-k
  imap <C-K> <Space>-><CR>
augroup END
