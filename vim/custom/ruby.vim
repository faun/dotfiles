augroup rubycomplete
  if !exists('ruby_completion_loaded')
    let g:ruby_completion_loaded = 1
    autocmd! Filetype ruby,eruby setlocal omnifunc=solargraph#CompleteSolar
  endif
augroup END

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

if !has('ruby')
    call s:ErrMsg( "Error: Rubycomplete requires vim compiled with +ruby" )
    call s:ErrMsg( "Error: falling back to syntax completion" )
    " lets fall back to syntax completion
    setlocal omnifunc=syntaxcomplete#Complete
    finish
endif
