#!/usr/bin/env bash
set -e

: ${DESTINATION:?"You must specify DESTINATION"}
echo "Installing dotfiles to $DESTINATION"

# Make src directory if it doesn't exist
mkdir -p "$DESTINATION"
cd "$DESTINATION"

if ! which git >/dev/null 2>&1
then
  echo "Please install git and try again"
fi

# Configure git to use 1Password
mkdir -p ~/.1password

if [[ -f "~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]]
then
 ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
fi

export SSH_AUTH_SOCK=~/.1password/agent.sock

ssh-add -l
ssh -T git@github.com || true

if [[ $(git rev-parse --is-inside-work-tree) ]]
then
  echo "Updating existing checkout"
  git diff-index --quiet --cached HEAD && \
    git checkout main && \
    git diff-index --quiet --cached HEAD && \
    git pull origin main --ff-only
else
  # Clone this repository to your machine & initialize submodules
  echo "Cloning repository"
  git clone --recursive "git@github.com:faun/dotfiles.git" .
fi

# Make symlinks to $HOME
./install.sh