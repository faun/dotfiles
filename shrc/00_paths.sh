#!/usr/bin/env bash
if [[ -z $TMUX ]]
then
  PATH="$PATH:$HOME/bin"
  PATH="$PATH:/usr/local/heroku/bin"
  PATH="$PATH:/usr/local/bin:/usr/local/sbin"
  PATH="$PATH:/opt/boxen/bin:/opt/boxen/homebrew/sbin:/opt/boxen/homebrew/bin"
  PATH="$PATH:/usr/local/mysql/bin"
  PATH="$PATH:/usr/local/git/bin"
  PATH="$PATH:$HOME/.cargo/bin"
  PATH="$PATH:$HOME/Library/Python/2.7/bin"
  PATH="$PATH:$HOME/.local/bin"
  PATH="$PATH:$HOME/perl5/bin";
  PATH="$HOME/.yarn/bin:$PATH"
  PATH="$HOME/.config/kubectx:$PATH"
  PATH=".git/safe/../../bin:$PATH"
  PATH=".git/safe/../../node_modules/.bin:$PATH"
  PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"
  export PATH

  MANPATH="/usr/local/man:$MANPATH"
  MANPATH="/usr/local/mysql/man:$MANPATH"
  MANPATH="/usr/local/git/man:$MANPATH"
  export MANPATH

  export GOPATH="$HOME/src"
  export NVM_DIR="$HOME/.nvm"
fi
