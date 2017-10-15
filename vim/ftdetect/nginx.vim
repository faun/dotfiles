au BufNewFile,BufRead nginx.conf set filetype=nginx

let g:neoformat_enabled_nginx = ['beautifier']

let g:neoformat_nginx_beautifier = {
            \ 'exe': 'nginxbeautifier',
            \ 'args': ['-s 4', '-i'],
            \ 'replace': 1
            \ }
