" Always show the sign column
set signcolumn=yes

" Namespace neomake gutter signs so they don't conflict with quickfixsigns
let g:quickfixsigns_protect_sign_rx = '^neomake_'

" Only show marks with quickfixsigns
let g:quickfixsigns_classes = ['marks']
