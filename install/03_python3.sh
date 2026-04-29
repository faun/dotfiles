#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1

# -----------------------------------------------------------------------------

eval "$(mise activate bash)"

installed_python_3_version="$(python3 --version 2>/dev/null | sed 's/Python //')"

latest_python_version=$(
  mise ls-remote python |
    grep -E '^3\.[0-9]+\.[0-9]+$' |
    grep --invert-match 'dev\|a\|b\|rc' |
    tail -1 2>/dev/null
)
echo "Latest python version: ${latest_python_version:?}"
echo "Installed python version: ${installed_python_3_version:?}"

if [[ "${installed_python_3_version:?}" != "${latest_python_version:?}" ]]; then
  echo "Installing Python ${latest_python_version:?}"
  mise use --global "python@${latest_python_version:?}"
fi

echo "Installing pip and neovim for Python3"

# Create virtualenv using mise's python
mise exec python@"${latest_python_version:?}" -- python -m venv "$HOME/.virtualenvs/py3neovim"

PYTHON3_PATH="$HOME/.virtualenvs/py3neovim/bin/python"
echo "$PYTHON3_PATH"

"$PYTHON3_PATH" -m pip install --upgrade pip setuptools wheel neovim >/dev/null

LOCAL_LUA="$HOME/.local.lua"
touch "$LOCAL_LUA"
if ! grep "python3_host_prog" "$LOCAL_LUA" >/dev/null 2>&1; then
  echo "Adding python3_host_prog to $LOCAL_LUA"
  echo "vim.g.python3_host_prog = '$PYTHON3_PATH'" >> "$LOCAL_LUA"
else
  # Update the existing line in case the path changed
  sed -i '' "s|vim.g.python3_host_prog = .*|vim.g.python3_host_prog = '$PYTHON3_PATH'|" "$LOCAL_LUA"
  echo "Updated python3_host_prog in $LOCAL_LUA"
fi

echo "Installing debugpy"

# Create debugpy virtualenv
mise exec python@"${latest_python_version:?}" -- python -m venv "$HOME/.virtualenvs/debugpy"
"$HOME/.virtualenvs/debugpy/bin/python" -m pip install --upgrade debugpy >/dev/null

# Symlink default packages so mise can use them
DOTFILES_DIR="$(git rev-parse --show-toplevel)"
if [[ -f "$DOTFILES_DIR/default-python-packages" ]]; then
  ln -sf "$DOTFILES_DIR/default-python-packages" "$HOME/.default-python-packages"
  echo "Linked default-python-packages for mise"
fi
