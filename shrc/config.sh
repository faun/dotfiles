# Ensure correct locale
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR='vim'

# Handle the fact that this file will be used with multiple OSs
platform=`uname`
if [[ $platform == 'Linux' ]]; then
  alias a='ls -lrth --color'
  alias ls='ls --color=auto'
elif [[ $platform == 'Darwin' ]]; then
  alias a='ls -lrthG'
  alias ls='ls -G'
  source "$(dirname $0)/optional/macos.sh"
  record_time "mac os"
fi

# enable rvm if it exists
if [[ "x$RVM_ROOT" == "x" ]]
then
  export RVM_ROOT="$HOME/.rvm"
fi

if [ -d $RVM_ROOT ]; then
  export PATH=$RVM_ROOT/bin:$PATH
  export rvm_path="$RVM_ROOT"
  [[ -s $rvm_path/scripts/rvm ]] && source $rvm_path/scripts/rvm
fi
record_time "rvm"

# otherwise use rbenv
if [[ "x$RBENV_ROOT" == "x" ]]
then
  export RBENV_ROOT=$HOME/.rbenv
fi

if [ -d $RBENV_ROOT ]; then
  export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
fi
record_time "rbenv paths"

# Base16 Shell
BASE16_SHELL="$HOME/.base16-shell/base16-tomorrow.dark.sh"
[[ -s $BASE16_SHELL ]] && . $BASE16_SHELL
record_time "Base16"

if [ -f $HOME/.local.sh ]; then
  source $HOME/.local.sh
  record_time "local.sh"
fi

[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
