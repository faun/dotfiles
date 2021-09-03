#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
DIR="$(pwd)"

# Install n from GitHub

N_PREFIX="${N_PREFIX:-$HOME/n}"
if ! [[ -d "$N_PREFIX" ]]; then
  curl -sL https://git.io/n-install | N_PREFIX=$N_PREFIX bash -s -- -q -y
else
  export N_PREFIX
  "$N_PREFIX/bin/n-update" -y
fi

n install lts

source "$DIR/../shrc/03_n.sh"
