" Turn on distraction free writing mode for markdown files
augroup DistractionFree
  autocmd!
  autocmd FileType * :Goyo!
  autocmd BufNew,BufNewFile,BufRead,BufEnter *.md,*.markdown :Goyo
augroup END
