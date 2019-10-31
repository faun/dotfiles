let g:go_fmt_command = "gofmt"
let g:go_fmt_autosave = 1

let g:go_metalinter_command = "golangci-lint"
let g:go_auto_sameids = 1

map <Leader>r :wa<CR> :GolangTestCurrentPackage<CR>
map <Leader>R :wa<CR> :GolangTestFocused<CR>


let g:projectionist_heuristics = {
      \ '*.go': {
      \   '*.go': {
      \       'alternate': '{}_test.go',
      \       'type': 'source'
      \   },
      \   '*_test.go': {
      \       'alternate': '{}.go',
      \       'type': 'test'
      \   },
      \ }}
