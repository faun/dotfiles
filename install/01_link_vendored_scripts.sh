#!/usr/bin/env bash
set -e
cd "$(dirname "$0")" || exit 1
DIR="$PWD"

REPOS_TO_CLONE=(
  ahmetb/kubectx
  alacritty/alacritty-theme
  rupa/z
)

for LINE in "${REPOS_TO_CLONE[@]}"; do
  NAME_OR_ORG="$(echo "$LINE" | awk -F "/" '{ print $1 }')"
  REPO_NAME="$(echo "$LINE" | awk -F "/" '{ print $2 }')"
  REPO_URL="https://github.com/${NAME_OR_ORG:?}/${REPO_NAME:?}.git"
  REPO_DEST="${HOME:?}/.config/${NAME_OR_ORG:?}/${REPO_NAME:?}"

  if [ -d "$REPO_DEST/.git" ]; then
    pushd "$REPO_DEST" >/dev/null
    echo "Updating ${REPO_NAME:?}"
    git pull -q --rebase --autostash &>/dev/null || true
    popd >/dev/null
  else
    echo "Cloning $REPO_URL to $REPO_DEST"
    mkdir -p "$(dirname "${REPO_DEST:?}")"
    git clone -q "$REPO_URL" "$REPO_DEST" || true
  fi
done

FILES_TO_LINK=(
  ${HOME:?}/.config/ahmetb/kubectx/kubectx
  ${HOME:?}/.config/ahmetb/kubectx/kubens
)

mkdir -p "${HOME:?}/bin"

for ENTRY in "${FILES_TO_LINK[@]}"; do
  TARGET="${ENTRY%%|*}"
  if [[ "$ENTRY" == *"|"* ]]; then
    FILE_NAME="${ENTRY##*|}"
  else
    FILE_NAME=$(basename "$TARGET")
  fi

  if [[ ! -f "$TARGET" ]]; then
    echo "Skipping $FILE_NAME: $TARGET does not exist"
    continue
  fi

  DESTINATION="${HOME:?}/bin/$FILE_NAME"
  if [[ -L "${DESTINATION:?}" ]]; then
    ln -sf "$TARGET" "$DESTINATION"
  elif [[ ! -e "$DESTINATION" ]]; then
    echo "Symlinking $TARGET to $DESTINATION"
    ln -s "$TARGET" "$DESTINATION"
  else
    echo "Destination file $DESTINATION already exists"
  fi
done
