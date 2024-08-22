#!/usr/bin/env bash

set -eou pipefail

#  Install jfind
REPO="jake-stewart/jfind"
REPO_DEST="/tmp/${REPO:?}"

git clone -q "https://github.com/${REPO}.git" "$REPO_DEST" || true

cd "$REPO_DEST" || exit 1

git pull -q --rebase --autostash &>/dev/null || true

cmake -S . -B build && cd build && sudo make install
