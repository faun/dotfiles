" RSpec Filetypes
autocmd BufNewFile,BufRead *_spec.rb set filetype=ruby.rails.rspec
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

function! AddEmptyLinesBetweenExamples()
  :%s/\(end\)\n\(\s\+\(it\|context\|describe\)\s\)/\1\r\r\2/g
endfunction
command! AddEmptyLinesBetweenExamples :call AddEmptyLinesBetweenExamples()

function! KillRSpecProcesses()
  silent! execute !ps | grep '[b]undle exec rspec' | awk '{ print $1 }' | xargs kill
endfunction
command! KillRSpecProcesses :call KillRSpecProcesses()
