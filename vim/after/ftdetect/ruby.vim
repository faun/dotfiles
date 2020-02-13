set makeprg=ruby\ -wc\ %

autocmd FileType ruby,ruby.rails,ruby.rails.rspec setlocal makeprg=ruby\ -wc\ %
autocmd FileType ruby.rails.rspec set ft=ruby
