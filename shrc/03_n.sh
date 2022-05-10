#!/usr/bin/env bash

N_PREFIX="${N_PREFIX:-$HOME/n}"
if [[ -d "$N_PREFIX" ]]; then
  export N_PREFIX
  PATH="$N_PREFIX/bin:$PATH"
  export PATH
fi
record_time "n node version manager"
