" delete matching matchpairs
nmap ds% <%mb%dd`bmedd`e

" Go to next/previous changed section of code
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" Stage/unstage one section of code at a time
nmap <Leader>ha <Plug>GitGutterStageHunk
nmap <Leader>hr <Plug>GitGutterUndoHunk

" Location list
nmap <Leader>o :lopen<CR>      " open location window
nmap <Leader>c :lclose<CR>     " close location window
nmap <Leader>, :ll<CR>         " go to current error/warning
nmap <Leader>n :lnext<CR>      " next error/warning
nmap <Leader>p :lprev<CR>      " previous error/warning
