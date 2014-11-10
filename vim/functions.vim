
" ==========================================
" Diff with buffer with original (from: http://vim.wikia.com/wiki/Diff_current_buffer_and_the_original_file)

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" ==========================================
" Search in project/directory

nnoremap <leader>/ :Ag<Space>
" Search current word in project/directory
" With or without word boundaries
function SearchInProject()
  let word = expand("<cword>")
  let @/=word
  set hls
  exec "Ag " . word
endfunction

function SearchWordInProject()
  let word = expand("<cword>")
  let @/='\<' . word . '\>'
  set hls
  exec "Ag '\\b" . word . "\\b'"
endfunction

nnoremap <leader>f :call SearchInProject()<CR>
nnoremap <leader>F :call SearchWordInProject()<CR>

