#!/usr/bin/env bash
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
