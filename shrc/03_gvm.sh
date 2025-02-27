#!/usr/bin/env bash

USE_GVM="${USE_GVM:-false}"
if [[ "$USE_GVM" != "false" ]]; then
  GVM_HOME="${GVM_HOME:-$HOME/.gvm}"
  if [[ -d "${GVM_HOME}" ]]; then
    [[ -s "${GVM_HOME:?}/scripts/gvm" ]] && source "${GVM_HOME:?}/scripts/gvm"
  fi
fi
