# directory listing & navigation
alias l="ls -lAh"
alias ll='ls -hl'
alias la='ls -a'
alias lla='ls -lah'

alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias q='exit'

# tmux
alias tat='tmux_attach'
alias t='tmux_attach'

# ruby
alias bi='bundle install'
alias bu='bundle update'
alias be='bundle exec'

# rails
alias tlog='tail -f log/development.log'
alias scaffold='script/generate nifty_scaffold'
alias migrate='rake db:migrate db:test:clone'
alias rst='touch tmp/restart.txt'

alias rdm="rake db:migrate"
alias rdtp="rake db:test:prepare"
alias rsa='rake spec:all'
alias rc='rails console'
alias rs='rails server'
alias rsd='rails server --debugger'
alias spec='/usr/bin/time bundle exec rspec'

# misc
alias retag='ctags -R --exclude=.svn --exclude=.git --exclude=log *'
alias f='find . -iname'
alias ducks='du -cksh * | sort -rn|head -11' # Lists folders and files sizes in the current folder
alias m='more'
alias df='df -h'
alias lm='!! | more'
alias '$'=' '

alias py='python'
alias sha1="openssl sha1"

alias vim_bundle_install='vim +PlugInstall +qall'
alias vim_bundle_clean='vim +PlugClean +qall'
alias v='vim'
alias vi='vim -u NONE -N'

# It's aliases all the way down
alias local_vim_bundles='$EDITOR $HOME/.bundles.local.vim'
alias local_gitconfig='$EDITOR $HOME/.gitconfig.local'
alias local_shell_conf='$EDITOR $HOME/.local.sh'
alias local_tmux_conf='$EDITOR $HOME/.tmux.local'
alias local_vimrc='$EDITOR $HOME/.vimrc.local'

alias showdirs="cat $HOME/.dirs | ruby -e \"puts STDIN.read.split.map{|x| x.gsub(/^(.+)=.+$/, '\1')}.join(', ')\""
