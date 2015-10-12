# Ensure correct locale
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR='vim'

typeset -F SECONDS
shell_start=$SECONDS

# timer functions
_last_recorded_time=$shell_start

print_recorded_times() {
  echo "$_recorded_times" | sort -nr
}

record_time() {
  local next_time=$SECONDS
  local line="$(printf "%d" $((($next_time - $_last_recorded_time) * 1000)))\t$1"
  _last_recorded_time=$next_time
  _recorded_times="$_recorded_times\n$line"
}

# Load optional platform-specific configuration
if [[ "$OSTYPE" == linux* ]]; then
  alias a='ls -lrth --color'
  alias ls='ls --color=auto'
elif [[ "$OSTYPE" == darwin* ]]; then
  alias a='ls -lrthG'
  alias ls='ls -G'
  source "$(dirname $0)/optional/macos.sh"
  record_time "mac os"
fi

# Enable rvm if it exists
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

# Set RBENV_ROOT to ~/.rbenv unless it exists
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
