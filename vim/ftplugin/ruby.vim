let b:ale_fixers = ['remove_trailing_lines', 'rubocop', 'trim_whitespace']

augroup Prettier
  autocmd!
  if get(g:, 'prettier#autoformat')
    autocmd BufWritePre *.ruby call prettier#Autoformat()
  endif
augroup end
