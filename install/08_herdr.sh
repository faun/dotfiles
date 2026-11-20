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

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=${HOME}/.config}"

tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

curl -fsSL https://releases.herdr.dev/core/install.sh -o "${tmp}/install.sh"
sh "${tmp}/install.sh"

# The herdr TUI this replaces had config.toml and sounds/ symlinked into
# ~/.config/herdr from this repo. Those sources are gone, so drop the dangling
# links. The rest of ~/.config/herdr is the TUI's own state (sockets,
# sessions), which is left alone.
for link in "${XDG_CONFIG_HOME}/herdr/config.toml" "${XDG_CONFIG_HOME}/herdr/sounds"; do
  if [[ -L "${link}" && ! -e "${link}" ]]; then
    echo "Removing dangling ${link}"
    rm -f "${link}"
  fi
done
