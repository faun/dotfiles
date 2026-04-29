#!/usr/bin/env bash

set -eou pipefail

apps=(
  # Xcode is excluded — it must be installed manually from the App Store under
  # the correct Apple ID. Command Line Tools (installed by 00_homebrew.sh) are
  # sufficient for most development work.
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
# Accept the Xcode license only when full Xcode.app is the active developer
# directory. Command Line Tools don't require (or support) this step.
if [[ "$(xcode-select -p 2>/dev/null)" == /Applications/Xcode*.app/Contents/Developer ]]; then
  echo "Agreeing to the Xcode license"
  sudo xcodebuild -license accept
fi
