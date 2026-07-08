#!/usr/bin/env bash
set -eou pipefail

# config/alacritty/alacritty.toml imports
# ~/.config/alacritty-theme/themes/nord.toml directly (no org prefix), so
# this clones there instead of going through 01_link_vendored_scripts.sh's
# generic ~/.config/<org>/<repo> convention.
DESTINATION="$HOME/.config/alacritty-theme/"
if [[ -d "$DESTINATION/.git" ]]; then
  (cd "$DESTINATION" && git pull -q --rebase --autostash || exit 1)
else
  git clone -q https://github.com/alacritty/alacritty-theme.git "$DESTINATION"
fi
