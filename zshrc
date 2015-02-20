typeset -F SECONDS
shell_start=$SECONDS

# timer functions
_last_recorded_time=$shell_start
record_time() {
  local next_time=$SECONDS
  local line="$(printf "%d" $((($next_time - $_last_recorded_time) * 1000)))\t$1"
  _last_recorded_time=$next_time
  _recorded_times="$_recorded_times\n$line"
}

print_recorded_times() {
  echo "$_recorded_times" | sort -nr
}

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

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && .  ~/.localrc
record_time "localrc"

if [[ -n $DEBUG_STARTUP_TIME ]]
then
  echo "Started up in $(printf "%d" $(($SECONDS * 1000)))ms"
  print_recorded_times
fi
