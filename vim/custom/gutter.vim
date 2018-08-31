" Always show the sign column
if exists('&signcolumn')
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" Namespace neomake gutter signs so they don't conflict with quickfixsigns
let g:quickfixsigns_protect_sign_rx = '^neomake_'

" Only show marks with quickfixsigns
let g:quickfixsigns_classes = ['marks']
