#!/usr/bin/env bash

if [[ -s "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -s "/opt/homebrew/bin/brew" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -n "$HOMEBREW_PREFIX" ]]; then
	PATH="${HOMEBREW_PREFIX:?}/bin:$PATH"
fi

HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
export HOMEBREW_PREFIX
