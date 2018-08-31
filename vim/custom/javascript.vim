" Javascript definition
autocmd BufNewFile,BufRead Gulpfile*,*.js,*.javascript,*.es,*.jsx set filetype=javascript
autocmd Filetype javascript setlocal et ts=2 sts=2 sw=2

" Autocomplete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

" JS Automatic formatting
" autocmd BufWritePre *.js,*.jsx Neoformat
" autocmd BufWritePre,TextChanged,InsertLeave *.js,*.jsx Neoformat

let g:neoformat_enabled_javascript = ['prettier']

" vim-jsx options
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

" Use formatprg when available
let g:neoformat_try_formatprg = 1

" JS Prettier options
nnoremap gp ma:silent %!prettier --config .prettierrc.js --stdin<CR>`a
autocmd FileType javascript setlocal formatprg=prettier\ --config\ .prettierrc.js\ --stdin

" Use formatprg when available
let g:neoformat_try_formatprg = 1

" Enable eslint for neomake
let g:neomake_javascript_enabled_makers = ['eslint']
