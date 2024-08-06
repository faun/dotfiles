#!/usr/bin/env bash
typeset -F SECONDS
shell_start=$SECONDS

# timer functions
_last_recorded_time=$shell_start

print_recorded_times() {
  echo "$_recorded_times" | sort -nr
}

  local next_time=$SECONDS
  local line="$(printf "%d" $((($next_time - $_last_recorded_time) * 1000)))\t$1"
  _last_recorded_time=$next_time
  _recorded_times="$_recorded_times\n$line"
}

