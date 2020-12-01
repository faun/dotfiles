augroup AutoLocalVimrc
  if exists('##VimSuspend')
    autocmd! FocusGained,BufEnter,WinEnter,VimResume * :silent! so .vimrc_local.vim
  else
    autocmd! FocusGained,BufEnter,WinEnter * :silent! so .vimrc_local.vim
  end
augroup END
