#!/usr/bin/env bash

USE_GVM="${USE_GVM:-true}"
GVM_HOME="${GVM_HOME:-$HOME/.gvm}"
if [[ "$USE_GVM" == "true" ]]; then
	[[ -s "${GVM_HOME:?}/scripts/gvm" ]] && source "${GVM_HOME:?}/scripts/gvm"

	GOROOT="${GOROOT:-${HOME:?}/src}"
	export GOROOT

	GOPATH="${HOME:?}/go"
	export GOPATH

	GOBIN="${GOPATH:?}/bin"
	export GOBIN

	PATH="${PATH}:${GOBIN}"
	export PATH
fi
