let b:ale_fixers = ['remove_trailing_lines', 'rubocop', 'trim_whitespace']

augroup Prettier
  autocmd!
  if get(g:, 'prettier#autoformat')
    autocmd BufWritePre *.ruby call prettier#Autoformat()
  endif
augroup end

let g:ale_fix_on_save = 1
let g:ale_fixers = {'ruby': ['rubocop'] }
