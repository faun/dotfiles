#!/usr/bin/env bash

set -eou pipefail

# Installs herdr-core (`hc`), the background runtime the Herdr desktop app
# (Homebrew cask herdr-app, see 00_homebrew_casks.sh) and the Herdr phone app
# attach to, locally or over SSH. Re-running it updates hc in place; running
# terminals keep running.
#
# No package manager ships herdr-core, so this uses the upstream installer.
# It is saved to a file rather than piped to sh. It checks the tarball's
# sha256 against the releases.herdr.dev manifest and installs into
# ~/.local/bin/herdr-core, with an `hc` symlink beside it.

cd "$(dirname "$0")/.." || exit 1
DIR="$(pwd)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=${HOME}/.config}"

tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

curl -fsSL https://releases.herdr.dev/core/install.sh -o "${tmp}/install.sh"
sh "${tmp}/install.sh"

# The herdr TUI runs alongside hc (Moshi's herdr support only drives the TUI).
# Its runtime state (sockets, session.json, logs) lives in ~/.config/herdr next
# to config.toml and a server may be running there, so link just the config
# file, not the directory. sounds/ holds only committed audio, so it is linked
# whole; config.toml's relative "sounds/..." paths resolve against it.
HERDR_CONFIG_DIR="${XDG_CONFIG_HOME}/herdr"
mkdir -p "${HERDR_CONFIG_DIR}"

for name in config.toml sounds; do
  source="${DIR}/config/herdr/${name}"
  target="${HERDR_CONFIG_DIR}/${name}"
  if [[ -L "${target}" || -e "${target}" ]]; then
    rm -rf "${target}"
  fi
  echo "Linking ${source} => ${target}"
  ln -s "${source}" "${target}"
done
