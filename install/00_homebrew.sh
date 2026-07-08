#!/usr/bin/env bash

set -e

cd "$(dirname "$0")" || exit 1
source ./_common.sh

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
  # Homebrew is not required on Linux: package installation goes through the
  # native package manager instead (see 00_homebrew_packages.sh).
  pm="$(detect_linux_package_manager)"
  case "$pm" in
    apt-get)
      sudo apt-get update
      sudo apt-get install -y build-essential curl file git
      ;;
    dnf)
      sudo dnf groupinstall 'Development Tools' -y
      sudo dnf install -y curl file git
      ;;
    yum)
      sudo yum groupinstall 'Development Tools' -y
      sudo yum install -y curl file git
      ;;
    *)
      echo "Unsupported Linux distribution: no apt-get, dnf, or yum found. Please install build tools, curl, file, and git manually."
      exit 1
      ;;
  esac
fi
