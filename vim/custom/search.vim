" ==========================================
" Search in project/directory

nnoremap <leader>/ :Ag<Space>
" Search current word in project/directory
" With or without word boundaries
function! SearchInProject()
  let word = expand("<cword>")
  let @/=word
  set hls
  exec "Ag " . word
endfunction

function! SearchWordInProject()
  let word = expand("<cword>")
  let @/='\<' . word . '\>'
  set hls
  exec "Ag '\\b" . word . "\\b'"
endfunction

nnoremap <leader>f :call SearchInProject()<CR>
nnoremap <leader>F :call SearchWordInProject()<CR>
