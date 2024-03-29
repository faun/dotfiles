#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1
DIR="$(pwd)"

"${DIR}/02_python_dependencies.sh"
set +u
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
set -u

# -----------------------------------------------------------------------------

installed_python2_version="$(python2 --version 2>/dev/null | sed 's/Python //')"

latest_python_2_version=$(
	pyenv install --list |
		sed 's/^  //' |
		grep '^2\.' |
		grep --invert-match 'dev\|a\|b\|rc' |
		tail -1
)

echo "Latest python version: $latest_python_2_version"
echo "Installed python version: $installed_python2_version"

if [[ "$installed_python2_version" != "$latest_python_2_version" ]]; then
	echo "Installing Python $latest_python_2_version"
	pyenv install -s "$latest_python_2_version"

	pyenv global "$latest_python_2_version"

	echo "Installing neovim for Python2"
	pip2 install --upgrade --force-reinstall pip setuptools wheel neovim

	if ! grep "g:python_host_prog" "$HOME/.vimrc.local" >/dev/null; then
		echo "Adding Neovim configuration for Python2"
		echo "let g:python_host_prog = '$(which python2)'" >>"$HOME/.vimrc.local"
	fi
fi

# -----------------------------------------------------------------------------

echo "Installing pip and neovim for Python2"

pyenv uninstall --force py2neovim

set +u

virtualenv_destination="$(pyenv root)/plugins/pyenv-virtualenv"
if ! [[ -d "$virtualenv_destination" ]]; then
	git clone https://github.com/pyenv/pyenv-virtualenv.git "$virtualenv_destination"
else
	(cd "$virtualenv_destination" && git reset --hard origin/master)
fi

pyenv virtualenv "$latest_python_2_version" py2neovim

pyenv activate py2neovim
PYTHON2_PATH="$(pyenv which python2)"
echo "$PYTHON2_PATH"

if ! grep "g:python_host_prog" "$HOME/.vimrc.local" >/dev/null; then
	pip2 install --upgrade --force-reinstall pip setuptools wheel neovim >/dev/null

	echo "Adding Neovim configuration for Python2"
	echo "let g:python_host_prog=\"$PYTHON2_PATH\"" >>"$HOME/.vimrc.local"
else
	echo "Please remove g:python_host_prog from $HOME/.vimrc.local and retry"
fi

# -----------------------------------------------------------------------------

pip_packages=(yamllint)
for egg in "${pip_packages[@]}"; do
	echo "Installing egg: $egg"
	pip2 install "$egg"
done
