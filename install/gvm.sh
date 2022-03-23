#!/usr/bin/env bash
set -eou pipefail

xcode-select --install >/dev/null 2>&1 || true
brew update || true
brew install mercurial || true

bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
gvm use system --default
