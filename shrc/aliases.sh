#!/usr/bin/env bash

alias d="z dotfiles; t"

# directory listing & navigation
alias l="ls -lAh"
alias ll='ls -hl'
alias la='ls -a'
alias lla='ls -lah'

alias ..='cd ..'
alias ...='cd .. ; cd ..'

# tmux
alias tat='tmux_attach'
alias t='tmux_attach'
alias tmux='tmux_attach'

# zellij (coexists with tmux, which stays the default multiplexer)
alias zj='zellij_attach'

# herdr (agent-aware multiplexer; coexists with tmux/zellij)
alias hd='herdr_attach'

# ruby
alias bi='bundle install'
alias bu='bundle update'
alias be='bundle exec'
alias r='bundle exec rspec'

# rails
alias tlog='tail -f log/development.log'
alias rst='touch tmp/restart.txt'

alias rdm="rake db:migrate"
alias rdtp="rake db:test:prepare"
alias rc='rails console'
alias rs='rails server'
alias spec='/usr/bin/time bundle exec rspec'

# misc
alias retag='ctags -R --exclude=.svn --exclude=.git --exclude=log *'
alias f='find . -iname'
alias ducks='du -cksh * | sort -rn|head -11' # Lists folders and files sizes in the current folder
alias m='more'
alias df='df -h'
alias lm='!! | more'
alias sane='stty sane'

alias py='python'
alias sha1="openssl sha1"

alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'

alias vim_bundle_install='vim +PlugInstall'
alias vim_bundle_update='vim +PlugUpdate +qall'
alias vim_bundle_clean='vim +PlugClean +qall'
alias vim_bundle_maintenance='vim +PlugInstall +PlugUpdate +PlugClean +qall'

if command -v nvim >/dev/null 2>&1; then
  VIM_EXE='nvim'
else
  VIM_EXE='vim'
fi

export EDITOR="$VIM_EXE"
alias vim="\$VIM_EXE -O"

# It's aliases all the way down
alias local_vim_bundles='$EDITOR $HOME/.bundles.local.vim'
alias local_gitconfig='$EDITOR $HOME/.gitconfig.local'
alias local_shell_conf='$EDITOR $HOME/.local.sh'
alias local_tmux_conf='$EDITOR $HOME/.tmux.local'
alias local_vimrc='$EDITOR $HOME/.vimrc.local'

confirm() {
  echo "${1:-Are you sure? [y/N]}"
  read -r answer
  if echo "$answer" | grep -iq "^y"; then
    return 0
  else
    return 1
  fi
}

migrations() {
  local migration_name
  migration_name="$(find ./db/migrate/* | sort -nr | fzf --reverse || exit 1)"

  if [[ -n $migration_name ]]; then
    vim -O "$migration_name"
  fi
}
