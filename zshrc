# Source shell-agnostic config files
for file in $HOME/.shrc/*.sh; do
  source "$file"
done

# Source zsh-specific files
for file in $HOME/.zsh/*.{zsh,sh}; do
  source "$file"
  record_time "$file"
done

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && .  ~/.localrc
record_time "localrc"

[[ -f $HOME/.iterm2_shell_integration.zsh ]] && source $HOME/.iterm2_shell_integration.zsh
record_time "iterm2 integration"

if [[ -d "$HOME/n" ]]
then
  export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
  record_time "n node version manager"
fi

if [[ -n $DEBUG_STARTUP_TIME ]]
then
  echo "Started up in $(printf "%d" $(($SECONDS * 1000)))ms"
  print_recorded_times
fi
