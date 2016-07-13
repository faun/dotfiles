" ==========================================
" Whitespace settings

function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction

" show tab and space characters
" set list listchars=tab:» ,nbsp:•,trail:·,extends:»,precedes:«

" Toggle invisible characters with leader-tab
nmap <silent> <leader><tab> :set nolist!<CR>

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=lightgrey guibg=lightgrey ctermfg=red guifg=lightred
match ExtraWhitespace /\s\+$/

" Remove trailing whitespace with F3
map <silent> <F3> :call TrimWhiteSpace()<CR>``

