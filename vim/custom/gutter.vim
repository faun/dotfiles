" Always show the sign column
let g:gitgutter_sign_column_always = 1

" Namespace neomake gutter signs so they don't conflict with quickfixsigns
let g:quickfixsigns_protect_sign_rx = '^neomake_'

" Only show marks with quickfixsigns
let g:quickfixsigns_classes = ['marks']
