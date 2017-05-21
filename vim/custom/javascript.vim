" Javascript definition
autocmd BufNewFile,BufRead Gulpfile*,*.js,*.javascript,*.es,*.jsx set filetype=javascript
autocmd Filetype javascript setlocal et ts=2 sts=2 sw=2

" Autocomplete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

" JS Automatic formatting
autocmd BufWritePre,TextChanged,InsertLeave *.js,*.jsx Neoformat
let g:neoformat_enabled_javascript = ['prettier']

" vim-jsx options
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

" JS Prettier options
nnoremap gp :silent %!prettier --stdin --trailing-comma all --single-quote<CR>
autocmd FileType javascript set formatprg=prettier\ --stdin\ --parser\ flow\ --single-quote\ --no-bracket-spacing\ --trailing-comma\ none
