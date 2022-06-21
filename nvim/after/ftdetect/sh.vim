autocmd FileType sh setlocal makeprg=shellcheck\ --format=gcc\ %

" Mark $ as a word character
setlocal iskeyword+=$
