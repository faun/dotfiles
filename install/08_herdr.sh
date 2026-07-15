#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")" || exit 1
cd .. || exit 1
DIR="$(pwd)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=${HOME}/.config}"

# Herdr keeps its runtime state (herdr.sock, herdr-client.sock, session.json,
# logs) in ~/.config/herdr — the SAME directory as config.toml — and a server
# may already be running there. So, unlike ghostty/zellij (whose config dirs
# hold only config and are symlinked whole), link just the config FILE: a
# directory-level symlink would drag live sockets/state into the repo and
# clobber the running server's state dir.
HERDR_CONFIG_DIR="${XDG_CONFIG_HOME}/herdr"
HERDR_CONFIG_SOURCE="${DIR}/config/herdr/config.toml"
HERDR_CONFIG_TARGET="${HERDR_CONFIG_DIR}/config.toml"

mkdir -p "${HERDR_CONFIG_DIR}"

if [[ -L "${HERDR_CONFIG_TARGET}" || -e "${HERDR_CONFIG_TARGET}" ]]; then
  rm -f "${HERDR_CONFIG_TARGET}"
fi

echo "Linking ${HERDR_CONFIG_SOURCE} => ${HERDR_CONFIG_TARGET}"
ln -s "${HERDR_CONFIG_SOURCE}" "${HERDR_CONFIG_TARGET}"

# sounds/ holds only committed audio assets (no live runtime state), so unlike
# the config dir as a whole, it's safe to symlink as a directory. This lets
# config.toml reference sound files with relative paths (e.g.
# "sounds/request.mp3"), since Herdr resolves those relative to config.toml's
# directory.
HERDR_SOUNDS_SOURCE="${DIR}/config/herdr/sounds"
HERDR_SOUNDS_TARGET="${HERDR_CONFIG_DIR}/sounds"

if [[ -L "${HERDR_SOUNDS_TARGET}" || -e "${HERDR_SOUNDS_TARGET}" ]]; then
  rm -rf "${HERDR_SOUNDS_TARGET}"
fi

echo "Linking ${HERDR_SOUNDS_SOURCE} => ${HERDR_SOUNDS_TARGET}"
ln -s "${HERDR_SOUNDS_SOURCE}" "${HERDR_SOUNDS_TARGET}"
