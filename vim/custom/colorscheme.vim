let g:base16colorspace=256

try
  colorscheme base16-twilight
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
endtry
