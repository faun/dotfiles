#!/usr/bin/env bash

set -eou pipefail

mkdir -p "$HOME/.local/share/nvim/site/pack/coc/start"
cd "$HOME/.local/share/nvim/site/pack/coc/start"
curl --fail -sSL https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -

nvim +:"CocInstall coc-json coc-tsserver coc-sh coc-snippets coc-prettier coc-eslint coc-pairs" +qa

# Install extensions
mkdir -p "$HOME/.config/coc/extensions"
cd "$HOME/.config/coc/extensions"
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
