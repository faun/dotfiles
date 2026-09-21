if [[ -n $DEBUG_STARTUP_TIME ]]; then
  # Run zprof to profile startup time
  zmodload zsh/zprof
fi

# -U keeps both arrays duplicate-free as later files prepend to them, which is
# what zsh offers instead of post-processing PATH through a pipeline.
typeset -U fpath path

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && . ~/.localrc

# Source shell-agnostic config files
for file in $HOME/.shrc/*; do
  if [[ -f "$file" ]]; then
    source "$file"
  fi
done

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Source zsh-specific files
for file in $HOME/.zsh/*; do
  if [[ -f "$file" ]]; then
    source "$file"
  fi
done

# Tool completions are cached into fpath by zsh/02_completions.sh rather than
# regenerated here on every shell.
zstyle ':completion:*:*:kubectl:*' list-grouped false

if [ -f $HOME/.local.sh ]; then
  source $HOME/.local.sh
fi

if [[ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/mysql-client/bin" ]]; then
  export PATH="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/mysql-client/bin:$PATH"
fi

if [[ -f ~/.gusto/init.sh ]]; then
  source ~/.gusto/init.sh
fi

# Collapse duplicate PATH entries, keeping the first of each. The -U attribute
# above only applies to array assignments, and every file here assigns the PATH
# string instead, so re-assigning the array is what actually triggers it. Last
# PATH edit in startup, so nothing re-introduces duplicates after this.
path=($path)

# Last in the file on purpose: anything below this never shows up in the profile.
if [[ -n $DEBUG_STARTUP_TIME ]]; then
  zprof
fi
