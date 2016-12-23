set makeprg=ruby\ -wc\ %

autocmd FileType ruby,ruby.rails,ruby.rails.rspec setlocal makeprg=ruby\ -wc\ %
autocmd FileType ruby.rails.rspec set ft=ruby

let g:neomake_ruby_enabled_makers=['mri', 'rubocop']
let g:neomake_verbose=4
