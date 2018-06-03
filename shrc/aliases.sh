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
alias b='bundle exec !!'
alias r='bundle exec rspec'

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
alias v='vim $(fzf)'
alias ducks='du -cksh * | sort -rn|head -11' # Lists folders and files sizes in the current folder
alias m='more'
alias df='df -h'
alias lm='!! | more'
alias sane='stty sane'

alias py='python'
alias sha1="openssl sha1"

# JavaScript
alias nombom='npm cache verify && bower cache clean && rm -rf node_modules bower_components && npm install && bower install'

alias vim_bundle_install='vim +PlugInstall'
alias vim_bundle_update='vim +PlugUpdate +qall'
alias vim_bundle_clean='vim +PlugClean +qall'
alias vim_bundle_maintenance='vim +PlugInstall +PlugUpdate +PlugClean +qall'

if command -v nvim >/dev/null 2>&1
then
  VIM_EXE='nvim'
else
  VIM_EXE='vim'
fi

export EDITOR="$VIM_EXE"
alias vim="\$VIM_EXE"
alias v="\$VIM_EXE"

# It's aliases all the way down
alias local_vim_bundles='$EDITOR $HOME/.bundles.local.vim'
alias local_gitconfig='$EDITOR $HOME/.gitconfig.local'
alias local_shell_conf='$EDITOR $HOME/.local.sh'
alias local_tmux_conf='$EDITOR $HOME/.tmux.local'
alias local_vimrc='$EDITOR $HOME/.vimrc.local'

kcontext() {
  kubectl config use-context "$(kubectl config get-contexts -o name | fzf)"
}

migrations() {
  local migration_name
  migration_name="$(find ./db/migrate/* | sort -nr | fzf --reverse || exit 1)"

  if [[ -n $migration_name ]]
  then
    vim -O "$migration_name"
  fi
}
