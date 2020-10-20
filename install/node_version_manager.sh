#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
# DIR="$(pwd)"

# Install n from GitHub

N_PREFIX="${N_PREFIX:-$HOME/n}"
echo "N_PREFIX: $N_PREFIX"
if ! [[ -d "$N_PREFIX/n" ]]; then
  curl -sL https://git.io/n-install | bash -s -- -q
else
  export N_PREFIX
  "$N_PREFIX/bin/n-update" -y
fi

