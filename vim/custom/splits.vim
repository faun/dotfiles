" ==========================================
" Window split key bindings
" See http://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/

" window
nmap \<left>  :topleft  vnew<CR>
nmap \<right> :botright vnew<CR>
nmap \<up>    :topleft  new<CR>
nmap \<down>  :botright new<CR>

" buffer
nmap <leader><left>   :leftabove  vnew<CR>
nmap <leader><right>  :rightbelow vnew<CR>
nmap <leader><up>     :leftabove  new<CR>
nmap <leader><down>   :rightbelow new<CR>

" new window splits gain focus
nnoremap <C-w>s <C-w>s<C-w>w
nnoremap <C-w>v <C-w>v<C-w>w

nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
