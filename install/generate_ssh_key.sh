#!/usr/bin/env bash

set -e

if ! [[ -f "$HOME/.ssh/id_rsa" ]]; then
  echo "Enter your email to generate an ssh key:"
  read -r SSH_KEY_EMAIL
  if [[ -n $SSH_KEY_EMAIL ]]; then
    ssh-keygen -t rsa -b 4096 -C "$SSH_KEY_EMAIL" -f "$HOME/.ssh/id_rsa"
    ssh-add -K "$HOME/.ssh/id_rsa"
    cat ~/.ssh/id_rsa.pub | pbcopy || true
  fi
else
  cat ~/.ssh/id_rsa.pub | tee >(pbcopy) || true
fi
