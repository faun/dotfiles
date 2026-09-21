#!/usr/bin/env bash
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
export NVM_DIR

GOBIN="${GOBIN:-$HOME/bin}"
export GOBIN

USE_HOMEBREW="${USE_HOMEBREW:-true}"
if [[ "$USE_HOMEBREW" == "true" ]]; then

  # Probe the known prefixes rather than forking `brew --prefix`, which costs
  # ~25ms to report what the install location already tells us. Order matters:
  # Apple Silicon, then Intel macOS, then Linuxbrew.
  if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
    for _brew_candidate in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
      if [[ -x "$_brew_candidate/bin/brew" ]]; then
        HOMEBREW_PREFIX="$_brew_candidate"
        break
      fi
    done
    unset _brew_candidate
  fi

  HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-"/opt/homebrew"}"
  export HOMEBREW_PREFIX

  if [[ -s "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [[ -s "${HOMEBREW_PREFIX:?}/bin/brew" ]]; then
    eval "$("${HOMEBREW_PREFIX:?}"/bin/brew shellenv)"
  fi
fi

if [[ -d "$HOME/.yarn/bin" ]]; then
  PATH="$PATH:$HOME/.yarn/bin"
fi

if [[ -d "$HOME/.config/kubectx" ]]; then
  PATH="$HOME/.config/kubectx:$PATH"
fi

if [[ -d "/usr/local/go/bin" ]]; then
  PATH="$PATH:/usr/local/go/bin"
fi

if [[ -d "$GOBIN" ]]; then
  PATH="$PATH:$GOBIN"
fi

if _safe_toplevel="$(git rev-parse --show-toplevel 2>/dev/null)" && \
   git config --file ~/.gitconfig.local --get-all safe.directory 2>/dev/null | grep -qxF "$_safe_toplevel"; then
  PATH="./bin:$PATH"
  PATH="./node_modules/.bin:$PATH"
fi
unset _safe_toplevel

if [[ -d /usr/local/bin ]]; then
  PATH="/usr/local/bin:$PATH"
fi

if [[ -d /usr/local/sbin ]]; then
  PATH="/usr/local/sbin:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/bin" ]]; then
  PATH="$HOME/bin:$PATH"
fi

export PATH
