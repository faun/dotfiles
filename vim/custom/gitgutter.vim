augroup AutoGitGutter
  autocmd! FocusGained,BufEnter,WinEnter * call gitgutter#all(1)
augroup END

" Go to next/previous changed section of code
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" Stage/unstage one section of code at a time
nmap <Leader>ha <Plug>GitGutterStageHunk
nmap <Leader>hr <Plug>GitGutterUndoHunk
