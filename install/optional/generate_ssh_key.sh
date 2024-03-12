#!/usr/bin/env bash

set -e

PRIVATE_KEY="$HOME/.ssh/id_ed25519"
if ! [[ -f "${PRIVATE_KEY:?}" ]]; then
	echo "Enter your email to generate an ssh key:"
	read -r SSH_KEY_EMAIL
	if [[ -n $SSH_KEY_EMAIL ]]; then

		ssh-keygen -t ed25519 -C "$SSH_KEY_EMAIL" -f "${PRIVATE_KEY:?}"
		if [[ "$OSTYPE" == darwin* ]]; then
			ssh-add --apple-use-keychain "${PRIVATE_KEY:?}"
		else
			ssh-add "${PRIVATE_KEY:?}"
		fi
	fi
fi
