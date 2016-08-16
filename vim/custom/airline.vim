let g:airline#extensions#tabline#enabled = 2
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.space = "\ua0"
let g:bufferline_echo = 0

let g:airline#extensions#tmuxline#enabled = 0
let g:airline_theme='base16_twilight'
let g:airline_extensions = ['branch', 'tabline']
let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
