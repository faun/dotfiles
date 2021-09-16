au BufNewFile,BufRead nginx.conf set filetype=nginx
au BufRead,BufNewFile *.nginx set ft=nginx
au BufRead,BufNewFile */etc/nginx/* set ft=nginx
au BufRead,BufNewFile */usr/local/nginx/conf/* set ft=nginx
au BufRead,BufNewFile nginx-*.conf set ft=nginx

let g:neoformat_enabled_nginx = ['beautifier']

let g:neoformat_nginx_beautifier = {
            \ 'exe': 'nginxbeautifier',
            \ 'args': ['-s 4', '-i'],
            \ 'replace': 1
            \ }
