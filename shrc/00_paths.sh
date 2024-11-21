#!/usr/bin/env bash
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
export NVM_DIR

GOPATH="${GOPATH:-$HOME/src}"
export GOPATH

GOBIN="${GOBIN:-$HOME/bin}"
export GOBIN

if command -v brew >/dev/null 2>&1; then
	HOMEBREW_PREFIX="$(brew --prefix)"
fi

HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-"/opt/homebrew"}"
export HOMEBREW_PREFIX

if [[ -s "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -s "${HOMEBREW_PREFIX:?}/bin/brew" ]]; then
	eval "$("${HOMEBREW_PREFIX:?}"/bin/brew shellenv)"
fi

if [[ -d "$HOME/.yarn/bin" ]]; then
	PATH="$PATH:$HOME/.yarn/bin"
fi

if [[ -d "$HOME/.config/kubectx" ]]; then
	PATH="$HOME/.config/kubectx:$PATH"
fi

if [[ -d "/usr/local/go/bin" ]]; then
	PATH="$PATH:/usr/local/go/bin"
fi

if [[ -d "$GOBIN" ]]; then
	PATH="$PATH:$GOBIN"
fi

PATH=".git/safe/../../bin:$PATH"
PATH=".git/safe/../../node_modules/.bin:$PATH"
PATH="$HOME/bin:$PATH"

if [[ -d /usr/local/bin ]]; then
	PATH="/usr/local/bin:$PATH"
fi
if [[ -d /usr/local/sbin ]]; then
	PATH="/usr/local/sbin:$PATH"
fi

export PATH
