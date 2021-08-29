#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
DIR="$(pwd)"

"${DIR}/python_dependencies.sh"

# -----------------------------------------------------------------------------

installed_python_3_version="$(python3 --version 2>/dev/null | sed 's/Python //')"

latest_python_version=$(
  set +u
  pyenv install --list |
    sed 's/^  //' |
    grep '^3\.' |
    grep --invert-match 'dev\|a\|b\|rc' |
    tail -1 2>/dev/null
  set -u
)
echo "Latest python version: $latest_python_version"
echo "Installed python version: $installed_python_3_version"

if [[ "$installed_python_3_version" != "$latest_python_version" ]]; then
  echo "Installing Python $latest_python_version"
  set +u
  pyenv install -s "$latest_python_version"
  pyenv global "$latest_python_version"
  set -u
fi

echo "Installing pip and neovim for Python3"

set +u
pyenv uninstall --force py3neovim
pyenv virtualenv "$latest_python_version" py3neovim
set -u

PYTHON3_PATH="$(
  set +u
  pyenv activate "$latest_python_version/envs/py3neovim"
  pyenv which python
  set -u
)"
echo "$PYTHON3_PATH"

set +u
pyenv activate py3neovim
set -u
pip3 install --upgrade pip setuptools wheel neovim >/dev/null

$PYTHON3_PATH -m pip install pynvim

if ! grep "g:python3_host_prog" "$HOME/.vimrc.local" >/dev/null; then
  echo "Adding Neovim configuration for Python3"
  echo "let g:python3_host_prog = '$PYTHON3_PATH'" >>"$HOME/.vimrc.local"
else
  echo "Please remove g:python3_host_prog from $HOME/.vimrc.local and retry"
fi

# -----------------------------------------------------------------------------

pip_packages=(yamllint)
for egg in "${pip_packages[@]}"; do
  echo "Installing egg: $egg"
  pip3 install "$egg"
done
