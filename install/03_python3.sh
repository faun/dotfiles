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

if ! grep "g:python3_host_prog" "$HOME/.vimrc.local" >/dev/null 2>&1; then
  echo "Adding Neovim configuration for Python3"
  echo "let g:python3_host_prog = '$PYTHON3_PATH'" >>"$HOME/.vimrc.local"
else
  echo "Please remove g:python3_host_prog from $HOME/.vimrc.local and retry"
fi

echo "Installing debugpy"

# Create debugpy virtualenv
mise exec python@"${latest_python_version:?}" -- python -m venv "$HOME/.virtualenvs/debugpy"
"$HOME/.virtualenvs/debugpy/bin/python" -m pip install --upgrade debugpy >/dev/null

# Symlink default packages so mise can use them
if [[ -f "$HOME/src/github.com/faun/dotfiles/default-python-packages" ]]; then
  ln -sf "$HOME/src/github.com/faun/dotfiles/default-python-packages" "$HOME/.default-python-packages"
  echo "Linked default-python-packages for mise"
fi
