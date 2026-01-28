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

# JavaScript
alias nombom='npm cache verify && bower cache clean && rm -rf node_modules bower_components && npm install && bower install'

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

kcontext() {
  kubectl config use-context "$(kubectl config get-contexts -o name | fzf)"
}

migrations() {
  local migration_name
  migration_name="$(find ./db/migrate/* | sort -nr | fzf --reverse || exit 1)"

  if [[ -n $migration_name ]]; then
    vim -O "$migration_name"
  fi
}

current_namespace() {
  local cur_ctx
  cur_ctx="$(current_context)"
  ns="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${cur_ctx}\")].context.namespace}")"
  if [[ -z "${ns}" ]]; then
    echo "default"
  else
    echo "${ns}"
  fi
}

confirm() {
  echo "${1:-Are you sure? [y/N]}"
  read -r answer
  if echo "$answer" | grep -iq "^y"; then
    return 0
  else
    return 1
  fi

}

current_context() {
  kubectl config view -o=jsonpath='{.current-context}'
}

strip_ansi() {
  if command -v strip-ansi >/dev/null 2>&1; then
    strip-ansi
  else
    npx strip-ansi-cli 2>/dev/null
    npm install --global strip-ansi-cli >/dev/null 2>&1 &
  fi
}

namespace_options() {
  kubens | strip_ansi | fzf || current_namespace
}

context_options() {
  kubectx | strip_ansi | fzf || current_context
}

alias k="kubectl"
alias kctx='kubectx'
alias kns='kubens "$(namespace_options)"'
alias ktx='kubectx "$(context_options)"'

kcapp() {
  if [[ $# -ne 1 ]]; then
    echo "Usage kcapp <app_label>"
    return 1
  fi

  kubectl get pod -l app="$1" \
    --sort-by=.status.startTime \
    --field-selector=status.phase=Running \
    -o=jsonpath='{.items[-1:].metadata.name}' |
    tail -1
}

kcin() {
  if [[ $# -ne 1 ]]; then
    echo "Usage kcin <istio_label>"
    return 1
  fi

  kubectl get -n istio-system pod -l istio="$1" \
    -o=jsonpath='{.items[-1:].metadata.name}'
}

kcimt() {
  if [[ $# -ne 1 ]]; then
    echo "Usage kcimt <istio-mixer-type>"
    return 1
  fi

  kubectl get -n istio-system pod -l istio-mixer-type="$1" \
    -o=jsonpath='{.items[-1:].metadata.name}'
}

alias kcistio=kcin

kcrelease() {
  if [[ $# -ne 1 ]]; then
    echo "Usage kcrelease <release_label>"
    return 1
  fi

  kubectl get pods -l release="$1" \
    --sort-by=.status.startTime \
    --field-selector=status.phase=Running \
    -o=jsonpath='{.items[-1:].metadata.name}' |
    tail -1
}

kcrun() {
  if [[ $# -ne 1 ]]; then
    echo "Usage krun <run_label>"
    return 1
  fi

  kubectl get pod -l run="$1" \
    -o=jsonpath='{.items[-1:].metadata.name}' |
    tail -1
}

kcx() {
  if [[ $# -lt 3 ]]; then
    echo "Usage kcx <pod> <container> [commands]"
    return 1
  fi

  kubectl exec -it "$1" -c "$2" -- "${@:3}"
}
