#!/usr/bin/env bash

USE_GVM="${USE_GVM:-false}"
if [[ "$USE_GVM" != "false" ]]; then
  GVM_HOME="${GVM_HOME:-$HOME/.gvm}"
  [[ -s "${GVM_HOME:?}/scripts/gvm" ]] && source "${GVM_HOME:?}/scripts/gvm"

  GOROOT="${GOROOT:-${HOME:?}/src}"
  export GOROOT

  GOPATH="${HOME:?}/go"
  export GOPATH

  GOBIN="${GOPATH:?}/bin"
  export GOBIN

  PATH="${PATH}:${GOBIN}"
  export PATH

  GOPROXY="${GOPROXY:-https://proxy.golang.org}"
fi
