#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")/.." || exit 1

git submodule update --init --recursive -- vim/pack
