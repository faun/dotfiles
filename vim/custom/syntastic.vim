" ==========================================
" Syntastic settings

let g:syntastic_javascript_syntax_checker = "jshint"
let g:syntastic_coffee_coffeelint_args = "--csv --file $HOME/.coffeelint.json"
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_ruby_rubocop_exec = "$RBENV_ROOT/shims/ruby $RBENV_ROOT/shims/rubocop"
let g:syntastic_check_on_open = 0
let g:syntastic_html_tidy_exec = ['tidy5']
let g:syntastic_scss_checkers = ['scss_lint']

