#!/usr/bin/env bash
set -e
cd "$(dirname "$0")" || exit 1
DIR="$PWD"

REPOS_TO_CLONE=(
	zsh-users/antigen
	jonmosco/kube-tmux
	ahmetb/kubectx
	rupa/z
	tmux-plugins/tpm
	alacritty/alacritty-theme
)

for LINE in "${REPOS_TO_CLONE[@]}"; do
	NAME=$(echo "$LINE" | cut -d'/' -f1)
	REPO=$(echo "$LINE" | cut -d'/' -f2)
	NAME=${TOKENS[0]}
	REPO=${TOKENS[1]}
	REPO_URL="https://github.com/$NAME/$REPO.git"
	REPO_DEST="$HOME/.config/$REPO"

	echo "Cloning $REPO_URL to $REPO_DEST"
	if [ -d "$REPO_DEST" ]; then
		pushd "$REPO_DEST" >/dev/null
		echo "Updating $REPO"
		git pull -q --rebase --autostash &>/dev/null || true
		popd >/dev/null
	else
		echo "Cloning $REPO_URL to $REPO_DEST"
		git clone -q "$REPO_URL" "$REPO_DEST" || true
	fi
done

FILES_TO_LINK=(
	ahmetb/kubectx/kubectx
	ahmetb/kubectx/kubens
)

symlink_files() {
	local OWNER="$1"
	shift
	local REPO="$1"
	shift
	local FILE_PATH="$1"
	mkdir -p "$HOME/bin"
	local TARGET="$HOME/.config/$REPO/$FILE_PATH"
	local DESTINATION="$HOME/bin/$FILE_PATH"
	if [[ ! -e "$DESTINATION" ]]; then
		echo "Symlinking $TARGET to $DESTINATION"
		ln -s "$TARGET" "$DESTINATION"
	else
		echo "Destination file $DESTINATION already exists"
	fi
}

for LINE in "${FILES_TO_LINK[@]}"; do
	declare -a FILE_TOKENS
	echo "$LINE"
	FILE_TOKENS=(
		"$(echo "$LINE" | awk 'BEGIN{FS="/"}{for (i=1; i<=NF; i++) print $i}')"
	)
	symlink_files "${FILE_TOKENS[@]}"
done
