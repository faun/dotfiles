#!/usr/bin/env bash
set -eou pipefail

DESTINATION="$HOME/.tmux/plugins/kube-tmux/"
if [[ -d "$DESTINATION" ]]; then
  (cd "$DESTINATION" && git pull || exit 1)
else
  mkdir -p "$(dirname "$DESTINATION")"
  git clone https://github.com/jonmosco/kube-tmux.git "$DESTINATION"
fi
chmod u+x "$DESTINATION/kube.tmux"
