#!/usr/bin/env bash

set -eou pipefail

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
if ! [[ -d "$XDG_CONFIG_HOME" ]]; then
  echo "The path at $XDG_CONFIG_HOME does not exist" >&2
  exit 1
fi

if [[ -d "${XDG_CONFIG_HOME}/vim/plugged/YouCompleteMe" ]]; then
  YCM_INSTALL_PATH="${XDG_CONFIG_HOME}/vim/plugged/YouCompleteMe"
elif [[ -d "${HOME}/.vim/plugged/YouCompleteMe" ]]; then
  YCM_INSTALL_PATH="${HOME}/.vim/plugged/YouCompleteMe"
else
  echo "Please install YouCompleteMe and try again"
  echo "Try running: vim +PlugInstall +qa"
  exit 1
fi

cd "$YCM_INSTALL_PATH" || (
  echo "Could not cd to $YCM_INSTALL_PATH"
  exit 1
)

latest_python_version=$(
  set +u
  pyenv install --list |
    sed 's/^  //' |
    grep '^3\.' |
    grep --invert-match 'dev\|a\|b\|rc' |
    tail -1 2>/dev/null
  set -u
)

set +u
FORMULAE=(llvm cmake openssl readline sqlite3 xz zlib tcl-tk bzip2 python3)
for FORMULA in "${FORMULAE[@]}"; do
  brew info "$FORMULA" >/dev/null 2>&1 || brew install "$FORMULA"
done

# if command -v pyenv >/dev/null 2>&1; then
#   eval "$(pyenv init -)"
#   eval "$(pyenv virtualenv-init -)"
#   # LDFLAGS="-L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib" \
#   # CPPFLAGS="-I$(brew --prefix zlib)/include -I$(brew --prefix bzip2)/include" \
#   # CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl)" \
#   # PYTHON_CONFIGURE_OPTS="--enable-shared" \
#   pyenv install -s "$latest_python_version"

#   pyenv virtualenv "$latest_python_version" py3ycm
#   pyenv activate "$latest_python_version/envs/py3ycm"

#   PYTHON3_PATH="$(pyenv which python)"
# else
# fi
PYTHON3_PATH="$(which python3)"

INSTALL_COMMAND=("$PYTHON3_PATH" "install.py" "--go-completer" "--ts-completer")
set -u

echo "Running ${INSTALL_COMMAND[*]}"

"${INSTALL_COMMAND[@]}"
