#!/usr/bin/env bash

set -e

if [ "$(uname)" == "Darwin" ]; then
homebrew_casks=()

INSTALLED_CASKS="$(brew list --cask --versions)"

for cask in "${homebrew_casks[@]}"; do
  if ! echo "$INSTALLED_CASKS" | awk '{ print $1 }' | grep "^$cask\$" >/dev/null; then
    echo "Installing cask: $cask"
    brew install "$cask" 2>/tmp/cask_error || true
    status=$?
    if [[ $status != 0 ]]; then
      echo "Cask $cask failed to install!"
      echo ---
      cat /tmp/cask_error
      echo ---
    fi
  else
    echo "Cask $cask already installed"
  fi
done
elif [ "$(expr substr "$(uname -s)" 1 5)" == "Linux" ]; then
  curl -sSL -o /tmp/gcp_install.sh https://sdk.cloud.google.com
  bash /tmp/gcp_install.sh --disable-prompts || true
else
  echo "Installing casks not supported"
fi
