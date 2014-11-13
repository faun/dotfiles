" Indent Guides
" =========================================
let g:indent_guides_auto_colors = 0
autocmd VimEnter,BufEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=234
autocmd VimEnter,BufEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
autocmd FileType html,css,ruby,eruby,javascript,php,xml,coffee call indent_guides#enable()
