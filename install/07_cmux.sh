#!/usr/bin/env bash

set -eou pipefail

# cmux (https://github.com/manaflow-ai/cmux) is a native macOS terminal for
# running AI coding agents (Claude Code, Codex, …) in parallel. Its config is
# version-controlled at config/cmux/cmux.json (symlinked to ~/.config/cmux by
# 01_dotfiles.sh); Claude Code notifications are wired automatically by cmux's
# Claude wrapper and toggled there via automation.claudeCodeIntegration.
#
# This step only installs the app via a Homebrew cask. It is skipped when cmux
# is already present so we don't fight a direct DMG install that self-updates
# via Sparkle.

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "cmux is macOS-only; skipping."
  exit 0
fi

if [[ -d "/Applications/cmux.app" ]] || command -v cmux >/dev/null 2>&1; then
  echo "cmux already installed; skipping."
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found; skipping cmux install."
  exit 0
fi

brew tap manaflow-ai/cmux
brew install --cask cmux

# The `cmux` CLI lives inside the app bundle and is added to PATH on first
# launch. If it isn't found yet, open cmux.app once to register it.
if ! command -v cmux >/dev/null 2>&1; then
  echo "Note: launch cmux.app once to register the 'cmux' CLI on PATH."
fi
