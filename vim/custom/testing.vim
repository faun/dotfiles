" =========================================
" Use vim-test and VTR to run tests and initiate REPL
"
" https://github.com/janko-m/vim-test
" https://github.com/christoomey/vim-tmux-runner

" Allow VTR to define a set of key mappings to provide easy access to the VTR
" command set. As a Vim user, I consider my <leader> space to be sacred, so
" these maps are disabled by default. To allow VTR to set its maps, add the
" following to your vimrc:

let g:VtrUseVtrMaps = 1

" The following normal mode maps are provided when g:VtrUseVtrMaps is set to 1:

"         Mapping      |   Command
"         -----------------------------
"         <leader>rr   |   VtrResizeRunner<cr>
"         <leader>ror  |   VtrReorientRunner<cr>
"         <leader>sc   |   VtrSendCommandToRunner<cr>
"         <leader>sl   |   VtrSendLinesToRunner<cr>
"         <leader>or   |   VtrOpenRunner<cr>
"         <leader>kr   |   VtrKillRunner<cr>
"         <leader>fr   |   VtrFocusRunner<cr>
"         <leader>dr   |   VtrDetachRunner<cr>
"         <leader>ar   |   VtrReattachRunner<cr>
"         <leader>cr   |   VtrClearRunner<cr>
"         <leader>fc   |   VtrFlushCommand<cr>

" In addition, a single visual mode map is provided to send a visually selected
" region to the runner pane:

"         Mapping      |   Command
"         -----------------------------
"         <leader>sv   |   VtrSendSelectedToRunner<cr>

" To re-attach to a pane, run the following:
"
" :VtrAttachToPane

" vim-test maps
nmap <silent> <leader><CR> :TestNearest<CR>
nmap <silent> <leader>\ :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

if exists('$TMUX')
  let g:test#strategy = 'vimux'
endif

let g:VtrOrientation = "h"
let g:VtrPercentage = 50

let test#javascript#teaspoon#options = {
  \ 'nearest': '--filter=',
  \ 'file':    'files=',
  \ 'suite':   '--suite=',
\}
let test#ruby#bundle_exec = 0

let test#go#gotest#options = {
  \ 'nearest': '-v',
  \ 'file':    '-v',
  \ 'suite':   '-v',
\}
