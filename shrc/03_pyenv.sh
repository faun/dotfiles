#!/usr/bin/env bash

# Set PYENV_ROOT to ~/.pyenv unless it exists
PYENV_ROOT="${PYENV_ROOT:-"${HOME:?}/.pyenv"}"
export PYENV_ROOT

if [ -d "$PYENV_ROOT" ]; then
	if command -v pyenv >/dev/null 2>&1; then
		eval "$(pyenv init -)"
		eval "$(pyenv virtualenv-init -)"
	fi
fi
