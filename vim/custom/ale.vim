let g:ale_enabled = 0
let g:ale_close_preview_on_insert = 1
let g:ale_sign_column_always = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_disable_lsp = 0
let g:ale_linters_explicit = 1
let g:ale_completion_enabled = 0
let g:ale_go_gometalinter_enabled = 0

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_pattern_options_enabled = 1
let g:ale_lint_on_text_changed = 'never'

let g:ale_open_list = 1
let g:ale_list_window_size = 5
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}

" let g:ale_fixers = {
"       \   'sh': ['shfmt'],
"       \   'go': ['gofumpt', 'goimports', 'remove_trailing_lines', 'trim_whitespace'],
"       \}

let g:ale_floating_preview = 1
let g:ale_hover_to_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']

" let g:ale_fixers = {
"       \   '*': ['remove_trailing_lines', 'trim_whitespace'],
"       \   'sh': ['shfmt'],
"       \   'proto': ['ale#fixers#protolint#Fix'],
"       \}

let g:ale_linters = {
      \   'ruby': ['rubocop'],
      \   'proto': ['protolint', 'protoc-gen-protolint'],
      \}

" let g:ale_linters = {
"       \   'go': ['gobuild', 'golangci-lint', 'gopls', 'staticcheck', 'errcheck'],
"       \}

let g:ale_pattern_options = {
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\ '\.vim$': {'ale_linters': [], 'ale_fixers': []},
\}
