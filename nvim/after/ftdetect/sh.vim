autocmd FileType sh setlocal makeprg=shellcheck\ --format=gcc\ %
let b:ale_linters = {
    \ 'sh': ['language_server'],
    \ }
