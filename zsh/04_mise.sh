#!/usr/bin/env bash

if command -v mise &>/dev/null; then
	eval "$(mise activate zsh)"
else
	echo "mise not found"
fi
