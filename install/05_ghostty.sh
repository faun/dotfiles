#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")" || exit 1
cd .. || exit 1
DIR="$(pwd)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=${HOME}/.config}"
mkdir -p "${XDG_CONFIG_HOME}"

GHOSTTY_CONFIG_SOURCE="${DIR}/config/ghostty"
GHOSTTY_CONFIG_TARGET="${XDG_CONFIG_HOME}/ghostty"

if [[ -L "${GHOSTTY_CONFIG_TARGET}" ]]; then
  rm "${GHOSTTY_CONFIG_TARGET}"
fi

echo "Linking ${GHOSTTY_CONFIG_SOURCE} => ${GHOSTTY_CONFIG_TARGET}"
ln -s "${GHOSTTY_CONFIG_SOURCE}" "${GHOSTTY_CONFIG_TARGET}"
