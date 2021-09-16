" Javascript definition
autocmd BufNewFile,BufRead Gulpfile*,*.js,*.javascript,*.es,*.jsx set filetype=javascript
autocmd Filetype javascript setlocal et ts=2 sts=2 sw=2

" Autocomplete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

autocmd FileType javascript setlocal formatprg=prettier\ --config\ .prettierrc.js\ --stdin 
