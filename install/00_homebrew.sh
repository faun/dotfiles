#!/usr/bin/env bash

set -e

install_homebrew_if_needed() {
  if ! command -v brew >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

if [[ "$OSTYPE" == darwin* ]]; then
  # Install Command Line Tools if missing (preferred over full Xcode).
  xcode-select --install >/dev/null 2>&1 || true

  # Accept the Xcode license only when full Xcode.app is the active developer
  # directory. CLT doesn't need it and xcodebuild will error if CLT is active.
  if [[ "$(xcode-select -p 2>/dev/null)" == /Applications/Xcode*.app/Contents/Developer ]]; then
    XCODE_EXIT_CODE=$(xcodebuild >/dev/null 2>&1; echo $?)
    if [[ "$XCODE_EXIT_CODE" = "69" ]]; then
      echo "Please accept the xcode license terms:"
      sudo xcodebuild -license accept
    fi
  fi

  install_homebrew_if_needed
elif [[ "$OSTYPE" == linux* ]]; then
  if command -v apt-get >/dev/null 2>&1; then
    PACKAGE_MANAGER="apt-get"
    sudo apt-get install build-essential curl file git
  elif command -v yum >/dev/null 2>&1; then
    PACKAGE_MANAGER="yum"
    sudo yum groupinstall 'Development Tools' -y
    sudo yum install curl file git -y
  elif command -v dnf >/dev/null 2>&1; then
    PACKAGE_MANAGER="dnf"
    sudo dnf groupinstall 'Development Tools' -y
    sudo dnf install curl file git -y
  else
    echo "Unsupported Linux distribution. Please install Homebrew manually."
    exit 1
  fi

  install_homebrew_if_needed
fi
