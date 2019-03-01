map <Leader>r :wa<CR> :GolangTestCurrentPackage<CR>
map <Leader>R :wa<CR> :GolangTestFocused<CR>
setl sw=4 ts=4 noet nolist

let g:go_fmt_autosave = 0
let g:go_fmt_command = "gofmt"
