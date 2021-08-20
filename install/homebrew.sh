#!/usr/bin/env bash

set -e

install_homebrew_if_needed() {
  if ! command -v brew >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

if [[ "$OSTYPE" == darwin* ]]; then
  # Accept the XCode license agreement
  XCODE_EXIT_CODE=$(
    xcodebuild >/dev/null 2>&1
    echo $?
  )
  if [[ "$XCODE_EXIT_CODE" = "69" ]]; then
    echo "Please accept the xcode license terms:"
    sudo xcodebuild -license accept
  fi

  xcode-select --install >/dev/null 2>&1 || true

  install_homebrew_if_needed
elif [[ "$OSTYPE" == linux* ]]; then
  sudo apt-get install build-essential curl file git

  install_homebrew_if_needed
fi

