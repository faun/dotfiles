#!/usr/bin/env bash
set -eou pipefail

REPO_URL="https://github.com/tmux-plugins/tpm"
DESTINATION="$HOME/.tmux/plugins/tpm"
if [[ -d "$DESTINATION" ]]; then
  (cd "$DESTINATION" && git pull || exit 1)
else
  git clone "$REPO_URL" "$DESTINATION"
fi
