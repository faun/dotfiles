autocmd BufNewFile,BufRead *.js.coffee.erb set filetype=eruby.coffee

" Compile CoffeeScript to scratch buffer with leader-c
vmap <leader>c <esc>:'<,'>:CoffeeCompile<CR>
map <leader>c :CoffeeCompile<CR>

" Jump to line in compiled JavaScript from CoffeScript source file
command! -nargs=1 C CoffeeCompile | :<args>
