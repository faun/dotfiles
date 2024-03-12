#!/usr/bin/env bash

set -eou pipefail

if ! [[ -d "$HOME/.local/share/nvim/site/pack/coc/start" ]]; then
	echo "Installing coc.nvim..."
	mkdir -p "$HOME/.local/share/nvim/site/pack/coc/start"
	cd "$HOME/.local/share/nvim/site/pack/coc/start"
	curl --fail -sSL https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -
fi

echo "Updating coc.nvim..."
nvim "+PlugUpdate" "+qa!" >/dev/null 2>&1
echo "Updating coc.nvim extensions..."
nvim "+CocUpdate" "+qa!"

echo "Installing extensions"
mkdir -p "$HOME/.config/coc/extensions"
cd "$HOME/.config/coc/extensions"
if [ ! -f package.json ]; then
	echo '{"dependencies":{}}' >package.json
fi
echo "Done"
