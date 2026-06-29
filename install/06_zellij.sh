#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")" || exit 1
cd .. || exit 1
DIR="$(pwd)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=${HOME}/.config}"
mkdir -p "${XDG_CONFIG_HOME}"

ZELLIJ_CONFIG_SOURCE="${DIR}/config/zellij"
ZELLIJ_CONFIG_TARGET="${XDG_CONFIG_HOME}/zellij"

if [[ -L "${ZELLIJ_CONFIG_TARGET}" ]]; then
  rm "${ZELLIJ_CONFIG_TARGET}"
fi

echo "Linking ${ZELLIJ_CONFIG_SOURCE} => ${ZELLIJ_CONFIG_TARGET}"
ln -s "${ZELLIJ_CONFIG_SOURCE}" "${ZELLIJ_CONFIG_TARGET}"
