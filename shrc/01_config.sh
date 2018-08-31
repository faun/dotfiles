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

# Enable rvm if it exists
if [[ "x$RVM_ROOT" == "x" ]]
then
  export RVM_ROOT="$HOME/.rvm"
fi

if [ -d "$RVM_ROOT" ]; then
  export PATH="$PATH:$RVM_ROOT/bin"
  # shellcheck disable=SC1090
  [[ -s "$RVM_ROOT/scripts/rvm" ]] && source "$RVM_ROOT/scripts/rvm"
fi
record_time "rvm"

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

# Set PYENV_ROOT to ~/.pyenv unless it exists
if [[ "x$PYENV_ROOT" == "x" ]]
then
  export PYENV_ROOT=$HOME/.pyenv
fi
record_time "pyenv paths"

if [ -d "$PYENV_ROOT" ]; then
  if which pyenv > /dev/null 2>&1
  then
    eval "$(pyenv init -)"
  fi
fi
record_time "pyenv initialization"

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

if [[ -n $LOAD_BOXEN ]]
then
  [ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
  record_time "boxen load time"
fi

if which nodenv > /dev/null
then
  NODE_PATH="$NODE_PATH:/opt/boxen/nodenv/versions/$(nodenv version)/lib/node_modules"
else
  NODE_PATH="/usr/local/lib/node_modules"
fi
export NODE_PATH
