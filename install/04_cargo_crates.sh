#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1

cargo_crates=(
  shellharden
)
for crate in "${cargo_crates[@]}"; do
  echo "Installing crate: $crate"
  cargo install "$crate"
done
