let b:ale_fixers = ['remove_trailing_lines', 'rubocop', 'trim_whitespace']

augroup Prettier
  autocmd!
  if get(g:, 'prettier#autoformat')
    autocmd BufWritePre *.ruby call prettier#Autoformat()
  endif
augroup end

autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
setlocal omnifunc=solargraph#CompleteSolar
execute RubySolarPrepare()
