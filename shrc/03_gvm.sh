#!/usr/bin/env bash
USE_GVM="${USE_GVM:-false}"
if [[ "$USE_GVM" == "false" ]]; then
	return
fi

# shellcheck source=/dev/null
[[ -f "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

GOROOT="${GOROOT:-${HOME:?}/src}"
export GOROOT

GOPATH="${HOME:?}/go"
export GOPATH

GOBIN="${GOPATH:?}/bin"
export GOBIN

PATH="${PATH}:${GOBIN}"
export PATH
