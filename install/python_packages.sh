#!/usr/bin/env bash
# Installs Python applications via pipx so each gets an isolated virtualenv.
# pynvim is a library (not a standalone app) so it goes into the neovim venv.

set -eou pipefail

pipx_packages=(
  black
  cmakelang
  djlint
  isort
  semgrep
  yamllint
  proselint
)

for package in "${pipx_packages[@]}"; do
  echo "Installing $package"
  pipx install "$package" || pipx upgrade "$package"
done

# pynvim must be installed into the neovim virtualenv, not as a standalone app
NEOVIM_VENV="$HOME/.virtualenvs/py3neovim"
if [[ -d "$NEOVIM_VENV" ]]; then
  echo "Installing pynvim into neovim venv"
  "$NEOVIM_VENV/bin/pip" install --upgrade pynvim
else
  echo "Neovim venv not found at $NEOVIM_VENV — run 03_python3.sh first"
fi
