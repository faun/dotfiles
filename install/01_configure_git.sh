#!/usr/bin/env bash

set -eou nounset

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
