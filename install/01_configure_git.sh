#!/usr/bin/env bash

set -eou nounset

# Ensure ~/.gitconfig is a *real*, machine-local file rather than a stale symlink
# into this repo. git resolves the `--global` write target to ~/.gitconfig when it
# exists and is readable, otherwise it falls back to ~/.config/git/config -- which
# is symlinked to the tracked config/git/config. Without a real ~/.gitconfig, any
# `git config --global ...` (e.g. tooling that runs `--add safe.directory "$(pwd)"`)
# silently writes into, and dirties, the tracked dotfiles config. Keeping a real
# ~/.gitconfig here redirects those writes to an untracked, machine-local file.
GLOBAL_GITCONFIG="${HOME:?}/.gitconfig"
if [[ -L "$GLOBAL_GITCONFIG" ]] || [[ ! -f "$GLOBAL_GITCONFIG" ]]; then
  rm -f "$GLOBAL_GITCONFIG"
  cat <<-'EOF' >"$GLOBAL_GITCONFIG"
	# Machine-local git config. NOT tracked in dotfiles.
	#
	# This file exists so that `git config --global ...` writes land here instead of
	# the symlinked, tracked ~/.config/git/config (dotfiles). git still reads the
	# tracked ~/.config/git/config and the included ~/.gitconfig.local; only the
	# --global *write* target is redirected here.

	# vim: set ft=gitconfig ts=2 sw=2 et:
	EOF
fi

GITCONFIG_FILE="${HOME:?}/.gitconfig.local"
if ! [[ -f "$GITCONFIG_FILE" ]]; then
  echo 'Configuring git'
  echo '---------------'
  echo 'Please enter your name:'
  read -r full_name
  echo 'Please enter your email:'
  read -r email
  echo 'Please enter your GitHub username:'
  read -r username

  if [[ -n $full_name ]] && [[ -n $email ]] && [[ -n $username ]]; then

    touch "$GITCONFIG_FILE"
    chmod u+w "$GITCONFIG_FILE"
    cat <<-EOF >"$GITCONFIG_FILE"
[user]
  name = $full_name
  email = $email

[github]
  user = $username
EOF
  fi
fi
