#!/usr/bin/env bash


if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
	export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

	if type brew &>/dev/null; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		if [[ -n "$HOMEBREW_PREFIX" ]]; then
      PATH="${HOMEBREW_PREFIX:?}/bin:$PATH"
    fi
	fi
fi

HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
export HOMEBREW_PREFIX
