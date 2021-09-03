#!/usr/bin/env bash
# shellcheck disable=SC1090

configure_antibody() {
  record_time "antibody autoload"

  source <(antibody init)
  record_time "antibody init"

  antibody_packages=(
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-history-substring-search
    lukechilds/zsh-better-npm-completion
  )

  for package in "${antibody_packages[@]}"; do
    antibody bundle "$package"
    record_time "$package"
  done
  record_time "antibody bundles"

  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down

  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down

  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down

  record_time "antibody keybindings"
}

if command -v antibody >/dev/null 2>&1; then
  configure_antibody
else
  echo "Couldn't find antibody binary"
fi
