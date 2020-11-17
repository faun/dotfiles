augroup AutoGitGutter
  autocmd! FocusGained,BufEnter,WinEnter * call gitgutter#all(1)
augroup END
