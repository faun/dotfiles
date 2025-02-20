#!/usr/bin/env bash

if [[ -f "${HOME:?}/.atuin/bin/env" ]]; then
  source "${HOME:?}/.atuin/bin/env"
fi

if command -v atuin >/dev/null 2>&1; then
  XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME:?}/.cache}"

  eval "$(atuin init zsh --disable-up-arrow)"

  if ! [[ -d "${XDG_CACHE_HOME:?}/zsh/completions" ]]; then
    mkdir -p "${XDG_CACHE_HOME:?}/zsh/completions"
  fi

  if ! [[ -f "${XDG_CACHE_HOME:?}/zsh/completions/_atuin" ]]; then
    atuin gen-completions --shell zsh >"${XDG_CACHE_HOME:?}/zsh/completions/_atuin"
    fpath+=("${XDG_CACHE_HOME:?}/zsh/completions")
  fi
fi
