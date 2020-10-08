#!/usr/bin/env bash

set -e

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
fi

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if [[ "$OSTYPE" == linux* ]]; then
  sudo apt-get install build-essential curl file git

  if ! [[ -d "$HOME/.linuxbrew" ]]; then
    git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
    test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
    test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
    test -r ~/.bash_profile && echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.bash_profile
    echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.profile
    export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
    export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
  fi
fi
