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
autocmd FileType javascript setlocal formatprg=prettier\ --stdin
nnoremap gp :silent %!prettier --stdin<CR>

" Use formatprg when available
let g:neoformat_try_formatprg = 1

" JS Beautify Options
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
autocmd FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
