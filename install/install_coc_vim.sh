#!/usr/bin/env bash

set -eou pipefail

if ! [[ -d "$HOME/.local/share/nvim/site/pack/coc/start" ]]; then
  mkdir -p "$HOME/.local/share/nvim/site/pack/coc/start"
  cd "$HOME/.local/share/nvim/site/pack/coc/start"
  curl --fail -sSL https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -
fi

nvim "+PlugUpdate" "+qa!" > /dev/null 2>&1
nvim "+CocUpdate" "+qa!"

# Install extensions
mkdir -p "$HOME/.config/coc/extensions"
cd "$HOME/.config/coc/extensions"
if [ ! -f package.json ]; then
  echo '{"dependencies":{}}' > package.json
fi
