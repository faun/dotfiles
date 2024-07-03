# Source shell-agnostic config files
for file in $HOME/.shrc/*; do
  if [[ -f "$file" ]]; then
    source "$file"
    record_time "$file"
  fi
done

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Source zsh-specific files
for file in $HOME/.zsh/*; do
  if [[ -f "$file" ]]; then
    source "$file"
    record_time "$file"
  fi
done

alias d="z dotfiles && t"

[[ -f $HOME/.iterm2_shell_integration.zsh ]] && source $HOME/.iterm2_shell_integration.zsh
record_time "iterm2 integration"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
record_time "fzf integration"

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && . ~/.localrc
record_time "localrc"

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
  zstyle ':completion:*:*:kubectl:*' list-grouped false
  record_time "kubectl completion"
fi

if [ $commands[kn] ]; then
  source <(kn completion zsh)
  record_time "kn completion"
fi

if [ -f $HOME/.local.sh ]; then
  source $HOME/.local.sh
  record_time "local.sh"
fi

if [[ -n $DEBUG_STARTUP_TIME ]]; then
  echo "Started up in $(printf "%d" $(($SECONDS * 1000)))ms"
  print_recorded_times
  clear
fi

[[ -s "/home/faun/.gvm/scripts/gvm" ]] && source "/home/faun/.gvm/scripts/gvm"
