#!/usr/bin/env bash

set -eou pipefail

curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path

source "$HOME/.cargo/env"

mkdir -p "$HOME/.zfunc"
rustup completions zsh >"$HOME/.zfunc/_rustup"

./install/04_cargo_crates.sh
