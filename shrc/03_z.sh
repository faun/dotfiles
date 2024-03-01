#!/usr/bin/env bash

Z_DIR="${Z_DIR:-"$HOME/.config/z"}"

if [[ -s "${Z_DIR:?}/z.sh" ]]; then
	source "${Z_DIR:?}/z.sh"
fi
