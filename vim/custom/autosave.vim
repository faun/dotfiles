set autoread
augroup AutoWrite
  autocmd! BufLeave,FocusLost,WinLeave * :silent! :w
  autocmd! FocusGained,BufEnter,WinEnter * :silent! !
augroup END
