#!/usr/bin/env bash
set -eou pipefail

if ! command -v go >/dev/null 2>&1; then
	brew install go || true
fi

GVM_HOME="${GVM_HOME:-$HOME/.gvm}"
if ! [[ -d "$GVM_HOME" ]]; then
	xcode-select --install >/dev/null 2>&1 || true
	brew install go || true
	brew update || true
	brew install mercurial || true
	brew install bison || true

	bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
	set +eu
	source "${GVM_HOME:?}/scripts/gvm"
	set -eu

	gvm use system --default || true
else
	echo "GVM is already installed, updating"

	gvm update || true
fi

INSTALLED_GO_VERSIONS="$(
	gvm list | sed '/^[[:space:]]*$/d' | awk '{$1=$1};1' | grep -vE '^gvm' | wc -l
)"

if [[ $INSTALLED_GO_VERSIONS -eq 0 ]]; then
	gvm listall | grep -E "   go" | grep -vE "beta|rc" | tail -n 20 | fzf --header-first --tac --no-sort --header="Select a Go version to install" | xargs gvm install
fi
