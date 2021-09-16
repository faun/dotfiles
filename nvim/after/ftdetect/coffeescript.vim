autocmd BufNewFile,BufRead *.js.coffee.erb,*.coffee set filetype=eruby.coffee
let g:test#runner_commands = ['Teaspoon']
let test#coffee#teaspoon#executable = 'bundle exec rake teaspoon'
