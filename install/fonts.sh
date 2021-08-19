#!/usr/bin/env bash

set -eou pipefail

brew tap | grep homebrew/cask-fonts >/dev/null || brew tap homebrew/cask-fonts

FONT_EXCLUSIONS=$(brew ls | grep -E '^font-' | xargs echo | tr " " "|" | tail -1)
INSTALLABLE_FONTS=$(brew search --casks for-powerline | grep -E '^font-' | grep -vE "$FONT_EXCLUSIONS")
FONT_TO_INSTALL="$(echo "$INSTALLABLE_FONTS" | fzf || true)"
if [[ "$FONT_TO_INSTALL" != "" ]]
then
  brew install "$FONT_TO_INSTALL"
else
  echo "Please select a font to install"
  exit 1
fi
