#!/usr/bin/env bash
# Installs the latest stable OpenTofu version via mise.

set -eou pipefail

cd "$(dirname "$0")" || exit 1

eval "$(mise activate bash)"

latest_opentofu_version=$(mise ls-remote opentofu | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | tail -1)
echo "Installing OpenTofu ${latest_opentofu_version:?}"
mise use --global "opentofu@${latest_opentofu_version:?}"
