let g:go_fmt_command = "gofmt"
let g:go_fmt_autosave = 1

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

let g:ale_go_gometalinter_enabled = 0
let g:go_metalinter_command = "golangci-lint"

let g:go_auto_sameids = 0
let g:go_highlight_structs = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_list_type = "quickfix"

map <Leader>r :wa<CR> :GolangTestCurrentPackage<CR>
map <Leader>R :wa<CR> :GolangTestFocused<CR>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

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

" autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
"
let b:ale_linters = ['gofmt']
