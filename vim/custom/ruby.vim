augroup rubycomplete
  if !exists('ruby_completion_loaded')
    let g:ruby_completion_loaded = 1
    autocmd! Filetype ruby,eruby setlocal omnifunc=solargraph#CompleteSolar
  endif
augroup END

let g:ruby_host_prog = '~/.rbenv/shims/neovim-ruby-host'
let g:ruby_path = system('echo $HOME/.rbenv/shims')

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

if !has('ruby')
    " lets fall back to syntax completion
    setlocal omnifunc=syntaxcomplete#Complete
    finish
endif
