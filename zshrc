record_time "setup"

# Source shell-agnostic config files
for file in $HOME/.shrc/*.sh; do
  source "$file"
  record_time "$file"
done

# Source zsh-specific files
for file in $HOME/.zsh/*.sh; do
  source "$file"
  record_time "$file"
done

# "z" script
z_script="/usr/local/etc/profile.d/z.sh"
[[ -f $z_script ]] && source $z_script
record_time "z"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
record_time "fzf"

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && .  ~/.localrc
record_time "localrc"

if [[ -n $DEBUG_STARTUP_TIME ]]
then
  echo "Started up in $(printf "%d" $(($SECONDS * 1000)))ms"
  print_recorded_times
fi
