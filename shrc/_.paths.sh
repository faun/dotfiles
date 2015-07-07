#!/usr/bin/env bash
if [[ -z $TMUX ]]
then
  PATH="$HOME/bin:$PATH"
  PATH=".git/safe/../../bin:$PATH"
  PATH="/usr/local/heroku/bin:$PATH"
  PATH="/usr/local/bin:/usr/local/sbin:$PATH"
  PATH="/opt/boxen/bin:/opt/boxen/homebrew/sbin:/opt/boxen/homebrew/bin:$PATH"
  PATH="/usr/local/mysql/bin:$PATH"
  PATH="/usr/local/git/bin:$PATH"
  export PATH

  MANPATH="/usr/local/man:$MANPATH"
  MANPATH="/usr/local/mysql/man:$MANPATH"
  MANPATH="/usr/local/git/man:$MANPATH"
  export MANPATH

  export NODE_PATH="/usr/local/lib/node_modules"
  export GOPATH="$HOME"
fi
