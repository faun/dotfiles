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

# zjstatus status-bar plugin used by layouts/spare.kdl. It replaces zellij's
# built-in compact-bar (which hardcodes a "Zellij (<session>)" label). Fetched
# rather than vendored, matching how the other install steps pull deps; pinned
# for reproducibility. Lives outside the symlinked config dir so it stays out
# of git — the layout references it via file:~/.local/share/zellij/plugins/.
ZJSTATUS_VERSION="v0.23.0"
ZJSTATUS_PLUGIN_DIR="${HOME}/.local/share/zellij/plugins"
ZJSTATUS_WASM="${ZJSTATUS_PLUGIN_DIR}/zjstatus.wasm"

if [[ ! -f "${ZJSTATUS_WASM}" ]]; then
  echo "Downloading zjstatus ${ZJSTATUS_VERSION} => ${ZJSTATUS_WASM}"
  mkdir -p "${ZJSTATUS_PLUGIN_DIR}"
  curl -fsSL -o "${ZJSTATUS_WASM}" \
    "https://github.com/dj95/zjstatus/releases/download/${ZJSTATUS_VERSION}/zjstatus.wasm"
fi
