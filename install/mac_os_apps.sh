#!/usr/bin/env bash

set -eou pipefail

apps=(
  497799835 # Xcode
)

INSTALLED_APPS="$(mas list | awk '{ print $1 }')"

for app_id in "${apps[@]}"; do
  APP_NAME="$(mas info "$app_id" | head -n 1)"
  if ! echo "$INSTALLED_APPS" | grep "^$app_id\$" >/dev/null; then
    echo "Installing $APP_NAME"
    mas install "$app_id" 2>/tmp/mas_error || true
    status=$?
    if [[ $status != 0 ]]; then
      echo "App $APP_NAME failed to install!"
      echo ---
      cat /tmp/mas_error
      echo ---
    fi
  else
    echo "App $APP_NAME already installed"
  fi
done
echo "Agreeing to the Xcode license"
sudo xcodebuild -license accept
