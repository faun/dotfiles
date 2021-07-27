# Enable bash completion script compatibility mode
# autoload -Uz bashcompinit; bashcompinit

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

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && . ~/.localrc
record_time "localrc"

[[ -f $HOME/.iterm2_shell_integration.zsh ]] && source $HOME/.iterm2_shell_integration.zsh
record_time "iterm2 integration"

if [[ -d "$HOME/n" ]]; then
  record_time "n node version manager"
fi

if [[ -n $DEBUG_STARTUP_TIME ]]; then
  echo "Started up in $(printf "%d" $(($SECONDS * 1000)))ms"
  print_recorded_times
fi

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi

# if [ $commands[kn] ]; then
#   source <(kn completion zsh)
# fi

# if which n >/dev/null 2>&1
# then
#   N_PREFIX="$HOME/n"
#   [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin" # Added by n-install (see http://git.io/n-install-repo).
# fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Short-circuit tabtab completion auto installation
# tabtab source for serverless package
# tabtab source for sls package
# tabtab source for slss package
