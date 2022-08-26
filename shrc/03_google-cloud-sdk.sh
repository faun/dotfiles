#!/usr/bin/env bash
# shellcheck disable=SC1090

HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-}"
if [[ "$HOMEBREW_PREFIX" == "" ]]; then
	if type brew &>/dev/null; then
		HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
	fi
fi

if [[ -d "${HOMEBREW_PREFIX:?}/Caskroom/google-cloud-sdk/latest/" ]]; then
	if [[ -n $ZSH_NAME ]]; then
		source "${HOMEBREW_PREFIX:?}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
		source "${HOMEBREW_PREFIX:?}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
	else
		source "${HOMEBREW_PREFIX:?}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
		source "${HOMEBREW_PREFIX:?}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
	fi
fi
