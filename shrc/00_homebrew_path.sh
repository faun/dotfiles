#!/usr/bin/env bash

if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
	export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

	if type brew &>/dev/null; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		PATH="${HOMEBREW_PREFIX}/bin:$PATH"
	fi
fi
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
export HOMEBREW_PREFIX
record_time "homebrew prefix"
