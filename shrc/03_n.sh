#!/usr/bin/env bash

if [[ "${USE_N:-false}" != "false" ]]; then

  # Use n by default
  N_PREFIX="${N_PREFIX:-$HOME/n}"
  if [[ -d "$N_PREFIX" ]]; then
    export N_PREFIX
    PATH="$N_PREFIX/bin:$PATH"
    export PATH
  else
    # Fall back to NVM
    export NVM_DIR="$([ "${XDG_CONFIG_HOME-}" = "" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  fi
fi
