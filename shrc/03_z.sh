#!/usr/bin/env bash

Z_SCRIPT="${Z_SCRIPT:-"$HOME/.config/rupa/z/z.sh"}"

if [[ -s "$Z_SCRIPT" ]]; then
	source "$Z_SCRIPT"
fi
