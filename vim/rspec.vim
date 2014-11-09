" RSpec Filetypes
autocmd BufNewFile,BufRead *_spec.rb set filetype=ruby.rails.rspec
autocmd BufNewFile,BufRead *.js.coffee.erb set filetype=eruby.coffee
autocmd BufNewFile,BufRead *_spec.rb compiler rspec

" ==========================================
" Promote variable to RSpec let

function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
command! PromoteToLet :call PromoteToLet()
map <leader>p :PromoteToLet<cr>
