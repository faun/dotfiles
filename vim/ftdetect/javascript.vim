" Javascript
autocmd Filetype javascript setlocal et ts=2 sts=2 sw=2
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd BufNewFile,BufRead Gulpfile* set filetype=javascript
autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

autocmd FileType javascript set formatprg=prettier\ --stdin\ --parser\ flow\ --single-quote\ --no-bracket-spacing\ --trailing-comma\ none

autocmd BufWritePre *.js Neoformat
