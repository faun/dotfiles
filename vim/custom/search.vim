" Ignore case if search pattern is all lowercase, case-sensitive otherwise
set smartcase

" Ignore case when searching
set ignorecase

" Highlight search terms
set hlsearch

" Show search matches as you type
set incsearch

" ==========================================
" Search in project/directory

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

if executable('ag')
  " Note we extract the column as well as the file and line number
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c%m
  let g:ackprg = 'ag --vimgrep'
endif

" Initiate search with <leader><space>
nnoremap <leader><space> :Ag<Space>

" Press leader-/ to toggle highlighting on/off, and show current value.
nnoremap <leader>/ :set hlsearch! hlsearch?<CR>

nnoremap <leader>* :call SearchInProject()<CR>
nnoremap <C-*>:call SearchWordInProject()<CR>

