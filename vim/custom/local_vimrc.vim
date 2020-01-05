augroup AutoLocalVimrc
  autocmd! FocusGained,BufEnter,WinEnter,VimResume * :silent! so .vimrc_local.vim
augroup END
