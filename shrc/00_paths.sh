#!/usr/bin/env bash
if [[ -z $TMUX ]]; then
  export NVM_DIR="$HOME/.nvm"
  export GOPATH="$HOME/src"
  export GOBIN="$HOME/bin"

  PATH="$PATH:$HOME/bin"
  PATH="$PATH:/usr/local/heroku/bin"
  PATH="$PATH:/usr/local/bin:/usr/local/sbin"
  PATH="$PATH:/usr/local/mysql/bin"
  PATH="$PATH:/usr/local/git/bin"
  PATH="$PATH:$HOME/.cargo/bin"
  PATH="$PATH:$HOME/Library/Python/2.7/bin"
  PATH="$PATH:$HOME/.local/bin"
  PATH="$PATH:$HOME/perl5/bin"
  PATH="$HOME/.yarn/bin:$PATH"
  PATH="$HOME/.config/kubectx:$PATH"
  PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"
  PATH=".git/safe/../../bin:$PATH"
  PATH=".git/safe/../../node_modules/.bin:$PATH"

  MANPATH="/usr/local/man:$MANPATH"
  MANPATH="/usr/local/mysql/man:$MANPATH"
  MANPATH="/usr/local/git/man:$MANPATH"

  export PATH
  export MANPATH
fi
