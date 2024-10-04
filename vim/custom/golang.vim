let g:go_gopls_enabled = 0

" Autosave settings for vim-go
let g:go_asmfmt_autosave = 0
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0
let g:go_mod_fmt_autosave = 0

" General settings for vim-go
let g:delve_use_vimux = 1
let g:go_auto_sameids = 0
let g:go_autodetect_gopath = 1
let g:go_code_completion_enabled = 0
let g:go_def_mapping_enabled = 0
let g:go_def_mapping_enabled = 0
let g:go_def_mode='gopls'
let g:go_diagnostics_enabled = 0
let g:go_diagnostics_level = 2 " 2 is for errors and warnings
let g:go_doc_balloon = 1
let g:go_doc_popup_window = 1
let g:go_fmt_command = 'gofumpt'
let g:go_fmt_fail_silently = 0
let g:go_fold_enable = []
let g:go_gopls_complete_unimported = 1
let g:go_gopls_enabled = 1
let g:go_gopls_gofumpt = 1
let g:go_gopls_options=['-remote=auto']
let g:go_gopls_staticcheck = 0
let g:go_highlight_build_constraints = 1
let g:go_highlight_diagnostic_errors = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_functions = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_imports_mode='gopls'
let g:go_info_mode='gopls'
let g:go_jump_to_error = 1
let g:go_list_height = 2
let g:go_list_type = 'locationlist'
let g:go_list_type_commands = {'GoMetaLinter': 'quickfix'}
let g:go_metalinter_autosave = 0
let g:go_metalinter_autosave_enabled = []
" let g:go_metalinter_enabled = ['errcheck', 'staticcheck', 'unused', 'gosec', 'ineffassign']
let g:go_metalinter_enabled = []
let g:go_metalinter_command = 'golangci-lint'
let g:go_metalinter_deadline = '5s'
let g:go_template_autocreate = 0
let g:go_test_show_name = 1

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
" autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
