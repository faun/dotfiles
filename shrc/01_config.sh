#!/usr/bin/env bash

# Ensure correct locale
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR='nvim'
[ -z "$TMUX" ] && export TERM=xterm-256color

# Load optional platform-specific configuration
if [[ "$OSTYPE" == linux* ]]; then
  alias a='ls -lrth --color'
  alias ls='ls --color=auto'
elif [[ "$OSTYPE" == darwin* ]]; then
  SHELL_TYPE="$(basename "$SHELL")"
  if [[ $SHELL_TYPE == 'bash' ]]
  then
    CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  else
    CURRENT_DIR=`dirname $0`
  fi
  alias a='ls -lrthG'
  alias ls='ls -G'
  [[ -f $CURRENT_DIR/optional/macos.sh ]] && source $CURRENT_DIR/optional/macos.sh
  record_time "mac os"
fi

# Set RBENV_ROOT to ~/.rbenv unless it exists
if [[ "x$RBENV_ROOT" == "x" ]]
then
  export RBENV_ROOT=$HOME/.rbenv
fi

if [ -d "$RBENV_ROOT" ]; then
  export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
fi
record_time "rbenv paths"

if [ -d "$RBENV_ROOT" ]; then
  export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
fi
record_time "rbenv paths"

# Source .profile if it exists
if [[ -f "$HOME/.profile" ]]
then
  source "$HOME/.profile"
fi

# Source .gpg-agent-info if it exists
if [[ -f "$HOME/.gpg-agent-info" ]]
then
  source "$HOME/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
  export SSH_AGENT_PID
fi
