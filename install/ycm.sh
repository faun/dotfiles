#!/usr/bin/env bash

cd "$HOME/.config/vim/plugged/YouCompleteMe" || exit
export PYTHON_CONFIGURE_OPTS="--enable-framework"

latest_python_version=$(
  set +u
  pyenv install --list |
    sed 's/^  //' |
    grep '^3\.' |
    grep --invert-match 'dev\|a\|b\|rc' |
    tail -1 2>/dev/null
  set -u
)

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  pyenv install -s "$latest_python_version"
  pyenv virtualenv "$latest_python_version" py3ycm
  pyenv activate "$latest_python_version/envs/py3ycm"

  PYTHON3_PATH="$(pyenv which python)"
else
  PYTHON3_PATH="$(which python3)"
fi

FORMULAE=(llvm cmake)
for FORMULA in "${FORMULAE[@]}"; do
  brew info "$FORMULA" >/dev/null 2>&1 || brew install "$FORMULA"
done
INSTALL_COMMAND=("$PYTHON3_PATH" "install.py" "--go-completer")

echo "Running ${INSTALL_COMMAND[*]}"

"${INSTALL_COMMAND[@]}"
