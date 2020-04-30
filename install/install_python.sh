#!/usr/bin/env bash
set -e

cd "$(dirname "$0")" || exit 1
DIR="$(pwd)"

# Install python for Deoplete and Ultisnips
# https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim

pip install --upgrade pip

if ! brew ls --versions | awk '{ print $1 }' | grep 'pyenv$' >/dev/null; then
  echo "Installing pyenv"
  brew install pyenv
fi

if ! brew ls --versions | awk '{ print $1 }' | grep 'readline' >/dev/null; then
  echo "Installing readline"
  brew install readline
fi

if ! brew ls --versions | awk '{ print $1 }' | grep 'xz' >/dev/null; then
  echo "Installing xz"
  brew install xz
fi

if [[ -d "$HOME/.pyenv/plugins/python-build/../.." ]]; then
  echo "Updating python-build"
  cd "$HOME/.pyenv/plugins/python-build/../.." && git pull && cd -
fi

latest_python_2_version=$(
  pyenv install --list |
    sed 's/^  //' |
    grep '^2\.' |
    grep --invert-match 'dev\|a\|b\|rc' |
    tail -1
)

echo "Installing Python $latest_python_2_version"
pyenv install -s "$latest_python_2_version"

echo "Installing neovim for Python2"
pip2 install --upgrade --force-reinstall pip setuptools wheel neovim

if ! grep "g:python_host_prog" "$HOME/.vimrc.local" >/dev/null; then
  echo "Adding Neovim configuration for Python2"
  echo "let g:python_host_prog = '$(which python2)'" >>"$HOME/.vimrc.local"
fi

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# -----------------------------------------------------------------------------

eval "$(pyenv init -)"

echo "Installing pip and neovim for Python2"

pyenv uninstall --force py2neovim

virtualenv_destination="$(pyenv root)/plugins/pyenv-virtualenv"
if ! [[ -d "$virtualenv_destination" ]]; then
  git clone https://github.com/pyenv/pyenv-virtualenv.git "$virtualenv_destination"
else
  (cd "$virtualenv_destination" && git reset --hard origin/master)
fi
pyenv virtualenv "$latest_python_2_version" py2neovim

pyenv activate py2neovim
PYTHON2_PATH="$(pyenv which python)"
echo "$PYTHON2_PATH"

pip install --upgrade --force-reinstall pip setuptools wheel neovim >/dev/null

if ! grep "g:python_host_prog" "$HOME/.vimrc.local" >/dev/null; then
  echo "Adding Neovim configuration for Python2"
  echo "let g:python_host_prog=\"$PYTHON2_PATH\"" >>"$HOME/.vimrc.local"
else
  echo "Please remove g:python_host_prog from $HOME/.vimrc.local and retry"
fi

# -----------------------------------------------------------------------------

latest_python_version=$(
  pyenv install --list |
    sed 's/^  //' |
    grep '^3\.' |
    grep --invert-match 'dev\|a\|b\|rc' |
    tail -1
)

echo "Installing Python $latest_python_version"
pyenv install -s "$latest_python_version"

echo "Installing pip and neovim for Python3"

pyenv uninstall --force py3neovim
pyenv virtualenv "$latest_python_version" py3neovim

PYTHON3_PATH="$(
  eval "$(pyenv init -)"
  pyenv activate "$latest_python_version/envs/py3neovim"
  pyenv which python
)"
echo "$PYTHON3_PATH"
pyenv activate py3neovim
pip3 install --upgrade pip setuptools wheel neovim >/dev/null

if ! grep "g:python3_host_prog" "$HOME/.vimrc.local" >/dev/null; then
  echo "Adding Neovim configuration for Python3"
  echo "let g:python3_host_prog = '$PYTHON3_PATH'" >>"$HOME/.vimrc.local"
else
  echo "Please remove g:python3_host_prog from $HOME/.vimrc.local and retry"
fi

pip_packages=(yamllint)
for egg in "${pip_packages[@]}"; do
  echo "Installing egg: $egg"
  pip install "$egg"
done
