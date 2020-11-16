set autoread
augroup AutoWrite
  autocmd! FocusLost,BufLeave,WinLeave * :silent! noautocmd w
  autocmd! FocusGained,BufEnter,WinEnter * :checktime
  autocmd! CursorHold,CursorHoldI * checktime
augroup END
