let g:ale_sign_column_always = 1
let g:ale_fix_on_save = 0
let g:airline#extensions#ale#enabled = 1

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_pattern_options_enabled = 1

let g:ale_open_list = 1
let g:ale_list_window_size = 5
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'vim': ['vint'],
\   'javascript': ['eslint'],
\   'sh': ['shfmt'],
\}
let g:ale_linters = {
\  'go': ['gofmt'],
\}

" Enable eslint for ale
let g:ale_pattern_options = {
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\}
