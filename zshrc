#
if [[ -n $DEBUG_STARTUP_TIME ]]; then
  # Run zprof to profile startup time
  zmodload zsh/zprof
fi

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

alias d="z dotfiles && t"

[[ -f $HOME/.iterm2_shell_integration.zsh ]] && source $HOME/.iterm2_shell_integration.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && . ~/.localrc

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
  zstyle ':completion:*:*:kubectl:*' list-grouped false
fi

if [ $commands[kn] ]; then
  source <(kn completion zsh)
fi

if [ -f $HOME/.local.sh ]; then
  source $HOME/.local.sh
fi

if [[ -n $DEBUG_STARTUP_TIME ]]; then
  zprof
fi
