#!/usr/bin/env bash
# Installs pipx, the Python application installer that manages its own venvs.
# On macOS, uses Homebrew to avoid PEP 668 externally-managed-environment errors.

set -eou pipefail

if command -v pipx >/dev/null 2>&1; then
  echo "pipx already installed"
  exit 0
fi

if [[ "$OSTYPE" == darwin* ]]; then
  brew install pipx
  pipx ensurepath
else
  python3 -m pip install --user pipx
  python3 -m pipx ensurepath
fi
