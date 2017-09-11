let g:neomake_ruby_enabled_makers = ['mri', 'rubocop']

augroup rubycomplete
  if !exists('ruby_completion_loaded')
    let g:ruby_completion_loaded = 1
    autocmd! FileType ruby,eruby setl ofu=rubycomplete#Complete
  endif
augroup END 

augroup fmt
  autocmd!
  autocmd BufWritePre *.rb Neoformat
augroup END
