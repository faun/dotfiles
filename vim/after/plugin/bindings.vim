" ,e to fast finding files. just type beginning of a name and hit TAB
nmap <leader>e :e **/

" Don't use Ex mode, use Q for formatting
map Q gq

" toggle highlight trailing whitespace
nmap <silent> <leader>s :set nolist!<CR>

" Ctrl-N to disable search match highlight
nmap <silent> <C-N> :silent noh<CR>

" Ctrol-E to switch between 2 last buffers
nmap <C-E> :b#<CR>

" center display after searching
nnoremap n   nzz
nnoremap N   Nzz
nnoremap *   *zz
nnoremap #   #zz
nnoremap g*  g*zz
nnoremap g#  g#z

map <F1> <nop>
imap <F1> <nop>
