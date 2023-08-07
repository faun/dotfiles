#!/usr/bin/env bash

# Initialize cargo if it exists
if [[ -d "$HOME/.cargo/bin" ]]; then
	export PATH="$HOME/.cargo/bin:$PATH"
	# shellcheck source=/dev/null
	. "$HOME/.cargo/env"
fi
