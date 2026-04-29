#!/usr/bin/env bash
# Installs the latest stable Go version via mise.

set -eou pipefail

cd "$(dirname "$0")" || exit 1

eval "$(mise activate bash)"

latest_go_version=$(mise ls-remote go | grep -E '^[0-9]+\.[0-9]+(\.[0-9]+)?$' | tail -1)
echo "Installing Go ${latest_go_version:?}"
mise use --global "go@${latest_go_version:?}"
