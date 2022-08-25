# Source shell-agnostic config files
for file in $HOME/.shrc/*; do
  if [[ -f "$file" ]]; then
    source "$file"
    record_time "$file"
  fi
done

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

if [[ -n $DEBUG_STARTUP_TIME ]]; then
  echo "Started up in $(printf "%d" $(($SECONDS * 1000)))ms"
  print_recorded_times
fi

if [ $commands[kubectl] ]; then
  source <(zsh kubectl completion zsh 2>/dev/null)
fi

# if [ $commands[kn] ]; then
#   source <(kn completion zsh)
# fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && . ~/.localrc
record_time "localrc"

function get_cluster_short() {
  echo "$1" | sed "s/planetscale-[[:digit:]]*-Planeteer-\(.*\)/\1/"
}

KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short
KUBE_PS1_SYMBOL_ENABLE=false
