#!/usr/bin/env bash
if [[ -z $TMUX ]]; then
	export NVM_DIR="$HOME/.nvm"
	export GOPATH="$HOME/src"
	export GOBIN="$HOME/bin"

  if [[ -d "/usr/local/mysql/bin" ]]; then
    PATH="$PATH:/usr/local/mysql/bin"
  fi

  if [[ -d "/usr/local/git/bin" ]]; then
    PATH="$PATH:/usr/local/git/bin"
  fi

  if [[ -d "$HOME/.local/bin" ]]; then
    PATH="$PATH:$HOME/.local/bin"
  fi

  if [[ -d "$HOME/.yarn/bin" ]]; then
    PATH="$PATH:$HOME/.yarn/bin"
  fi

  RBENV_ROOT="${RBENV_ROOT:-$HOME/.rbenv}"
  if [ -d "$RBENV_ROOT" ]; then
    PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
  fi

  PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
  if [[ -d "$PYENV_ROOT" ]]; then
    PATH="$HOME/.pyenv/bin:$PATH"
    PATH="$HOME/.pyenv/shims:$PATH"
  fi

  if [[ -d "$HOME/.config/kubectx" ]]; then
    PATH="$HOME/.config/kubectx:$PATH"
  fi

  if [[ -d "/usr/local/go/bin" ]]; then
    PATH="$PATH:/usr/local/go/bin"
  fi

  if [[ -z $GOPATH ]]; then
    GOPATH="$HOME/src"
  fi

  if [[ -z $GOBIN ]]; then
    GOBIN="$HOME/bin"
  fi

  if [[ -d "$GOBIN" ]]; then
    PATH="$PATH:$GOBIN"
  fi

  if [[ -d "$GOPATH/bin" ]]; then
    PATH="$PATH:$GOPATH/bin"
  fi

  PATH=".git/safe/../../bin:$PATH"
  PATH=".git/safe/../../node_modules/.bin:$PATH"
  PATH="$HOME/bin:$PATH"

	if [[ -d /usr/local ]]; then
		MANPATH="/usr/local/man:$MANPATH"
		MANPATH="/usr/local/mysql/man:$MANPATH"
		MANPATH="/usr/local/git/man:$MANPATH"
		PATH="/usr/local/bin:/usr/local/sbin:$PATH"
	fi

	export PATH
	export RBENV_ROOT
	export MANPATH
fi
