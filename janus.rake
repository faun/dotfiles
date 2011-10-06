# See https://github.com/jackkinsella/dotfiles/blob/master/janus.rake
def remove_plugin_task(name)
  task(name).clear
  task("#{name}:pull").clear
  task("#{name}:install").clear
  file(File.expand_path("tmp/#{name}") => "tmp").clear
end

def override_plugin_task(name, repo=nil, &block)
  remove_plugin_task name
  vim_plugin_task name, repo, &block
end

def extend_plugin_task(name, &block)
  task "#{name}:install" do
    yield block
  end
end
vim_plugin_task "tabular", "git://github.com/godlygeek/tabular.git"
vim_plugin_task "gundo", "git://github.com/sjl/gundo.vim.git"
# vim_plugin_task "velocity", "git://github.com/vim-scripts/velocity.vim.git"
vim_plugin_task "ragtag", "git://github.com/tpope/vim-ragtag.git"
vim_plugin_task "peepopen", "git://github.com/mrchrisadams/vim-peepopen.git"
vim_plugin_task "snipmate-snippets", "git://github.com/scrooloose/snipmate-snippets.git"
vim_plugin_task "css-snippets-snipmate", do
  sh "curl 'https://raw.github.com/tisho/css-snippets-snipmate/master/css.snippets' -o snippets/css.snippets"
end

vim_plugin_task "ruby", "https://github.com/vim-ruby/vim-ruby.git"
vim_plugin_task "repeat", "git://github.com/tpope/vim-repeat.git"
vim_plugin_task "liquid", "git://github.com/vim-ruby/vim-ruby.git"
vim_plugin_task "scss", "https://github.com/cakebaker/scss-syntax.vim.git"
vim_plugin_task "sinatra", "https://github.com/hallison/vim-ruby-sinatra.git"
vim_plugin_task "less", "git://gist.github.com/369178.git"
vim_plugin_task "camelcasemotion", "https://github.com/vim-scripts/camelcasemotion.git"
vim_plugin_task "zencoding", "https://github.com/mattn/zencoding-vim.git"
vim_plugin_task "session", "https://github.com/vim-scripts/session.vim--Odding.git"
vim_plugin_task "delimitMate", "https://github.com/Raimondi/delimitMate.git"
vim_plugin_task "css-color", "https://github.com/ap/vim-css-color.git" do
  sh "cp after/syntax/{css,less}.vim"
  sh "cp after/syntax/{css,scss}.vim"
end
vim_plugin_task "hammer",           "git://github.com/robgleeson/hammer.vim.git" do
  sh "gem install github-markup redcarpet"
end

vim_plugin_task "html5-syntax",     "git://github.com/othree/html5-syntax.vim.git"

vim_plugin_task "lesscss",          "git://gist.github.com/161047.git" do
  FileUtils.cp "tmp/lesscss/less.vim", "syntax"
end

vim_plugin_task "html5",            "git://github.com/othree/html5.vim.git" do
  Dir.chdir "tmp/html5" do
    sh "make install"
  end
end

vim_plugin_task "copy-as-rtf", "git://github.com/aniero/vim-copy-as-rtf.git"
