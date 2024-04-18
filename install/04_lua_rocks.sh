#!/usr/bin/env bash
set -eou pipefail

cd "$(dirname "$0")" || exit 1

if ! command -v luarocks >/dev/null; then
	echo "Please install lua first"
	exit 1
fi

lua_rocks=(
	luacheck
)

for rock in "${lua_rocks[@]}"; do
	echo "Installing rock: ${rock:?}"
	luarocks install "${rock:?}" 2>/dev/null || true
done
