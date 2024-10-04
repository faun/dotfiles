#!/usr/bin/env bash
# shellcheck disable=SC1090

HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-}"
if [[ "$HOMEBREW_PREFIX" == "" ]]; then
	if type brew &>/dev/null; then
		HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
	fi
fi

if [ -d "${HOMEBREW_PREFIX}/etc/bash_completion.d" ]; then
	export BASH_COMPLETION_COMPAT_DIR="${HOMEBREW_PREFIX}/etc/bash_completion.d"
fi

if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
	source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi
