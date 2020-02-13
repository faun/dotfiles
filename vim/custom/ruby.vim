augroup rubycomplete
  if !exists('ruby_completion_loaded')
    let g:ruby_completion_loaded = 1
    autocmd! FileType ruby,eruby setl ofu=rubycomplete#Complete omnifunc=ale#completion#OmniFunc
  endif
augroup END 
