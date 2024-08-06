#!/usr/bin/env bash
# shellcheck disable=SC1090

configure_antidote() {

	source <(antidote init)

	ANTIDOTE_PACKAGES="$(
		cat <<EOF
		zsh-users/zsh-syntax-highlighting
		zsh-users/zsh-autosuggestions
		zsh-users/zsh-history-substring-search
		lukechilds/zsh-better-npm-completion
EOF
	)"
	ANTIDOTE_PLUGINS_PATH="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
	if ! [[ -f "${ANTIDOTE_PLUGINS_PATH:?}" ]]; then
		echo "${ANTIDOTE_PACKAGES:?}" >"${ANTIDOTE_PLUGINS_PATH:?}"
	fi
	antidote load "${ANTIDOTE_PLUGINS_PATH:?}"

	bindkey '^[[A' history-substring-search-up
	bindkey '^[[B' history-substring-search-down

	bindkey -M emacs '^P' history-substring-search-up
	bindkey -M emacs '^N' history-substring-search-down

	bindkey -M vicmd 'k' history-substring-search-up
	bindkey -M vicmd 'j' history-substring-search-down

}

ANTIDOTE_PATH="${ZDOTDIR:-$HOME}/.antidote"
if ! [[ -d "$ANTIDOTE_PATH" ]]; then
	git clone --depth=1 https://github.com/mattmc3/antidote.git "${ANTIDOTE_PATH:?}" || true
fi

if [[ -d "${ANTIDOTE_PATH:?}" ]]; then
	source "${ANTIDOTE_PATH:?}/antidote.zsh"
fi

if command -v antidote >/dev/null 2>&1; then
	configure_antidote
else
	echo "Couldn't find antidote binary"
fi
