autocmd BufEnter Capfile set ft=ruby
autocmd FileType ruby set ft=ruby.rails.ruby-rails.ruby-rspec
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 4
imap <C-l> <Space>=><Space>
              "Make hashrocket with control-l
map <F7> :wall<esc> :!rspec --color<CR>

