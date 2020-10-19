" ==========================================
" Ctags

noremap <leader>pt :!ctags -V --languages=ruby -f .gems.tags `gem env gemdir` && ctags -f .tags -RV . <cr>

set tags=tags,./tags,./.tags,./.gems.tags
