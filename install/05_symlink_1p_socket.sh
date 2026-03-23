#!/usr/bin/env bash

set -euo pipefail

if [[ -d ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t ]]; then
  mkdir -p ~/.1password
  ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
fi
