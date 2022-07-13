set autoread

let updatetime = 5000

augroup AutoWrite
  autocmd!
  autocmd FocusLost,BufLeave,VimLeavePre,WinLeave,VimSuspend * silent! noautocmd w
augroup END

augroup AutoRead
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() == 'n' && getcmdwintype() == '' | checktime | endif
  autocmd FocusGained,BufEnter,VimEnter,WinEnter,VimResume * silent! checktime
augroup END
