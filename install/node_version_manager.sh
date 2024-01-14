#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
DIR="$(pwd)"

# Install n from GitHub

N_PREFIX="${N_PREFIX:-$HOME/n}"
export N_PREFIX

if ! [[ -d "$N_PREFIX" ]]; then
  curl -o ./n-install -sSL https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install
  chmod u+x ./n-install
  ./n-install -q -y
else
  "$N_PREFIX/bin/n-update" -y
fi

PATH="$PATH:${N_PREFIX}/bin"
export PATH

if ! command -v n
then
  echo "Failed to install node package manager" >&2
  exit 1
fi

n install lts

source "$DIR/../shrc/03_n.sh"
