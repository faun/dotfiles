" =========================================
" Use vim-test to run tests and initiate REPL
"
" https://github.com/janko-m/vim-test

" vim-test maps
nmap <silent> <leader><CR> :TestNearest<CR>
nmap <silent> <leader>\ :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>
nmap <silent> <leader>tb :GoToggleBreakpoint<CR>

if exists('$TMUX')
  let g:test#strategy = 'vimux'
endif

let g:VimuxHeight = "40"
let g:VimuxOrientation = "h"

let test#javascript#teaspoon#options = {
  \ 'nearest': '--filter=',
  \ 'file':    'files=',
  \ 'suite':   '--suite=',
\}
let test#ruby#bundle_exec = 0
