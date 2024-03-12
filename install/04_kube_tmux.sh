#!/usr/bin/env bash
set -eou pipefail

DESTINATION="$HOME/.config/kube-tmux/"
if [[ -d "$DESTINATION" ]]; then
  (cd "$DESTINATION" && git pull || exit 1)
else
  git clone git@github.com:jonmosco/kube-tmux.git "$DESTINATION"
fi
chmod u+x "$DESTINATION/kube.tmux"
