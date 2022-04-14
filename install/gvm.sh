#!/usr/bin/env bash
set -eou pipefail

GVM_HOME="${GVM_HOME:-$HOME/.gvm}"
if ! [[ -d "$GVM_HOME" ]]; then
  xcode-select --install >/dev/null 2>&1 || true
  brew update || true
  brew install mercurial || true

  bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  gvm use system --default
else
  echo "GVM is already installed, updating"
  gvm update
fi
