augroup AutoWrite
  autocmd! BufLeave * :update
  autocmd! FocusLost * :update
  autocmd! BufEnter * silent! :e % :set syntax=enable
  autocmd! FocusGained * silent! :e % :set syntax=enable
augroup END
