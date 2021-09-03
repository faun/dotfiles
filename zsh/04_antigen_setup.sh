#!/usr/bin/env bash
# shellcheck disable=SC1090

# XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
# ANTIGEN_PATH="${XDG_CONFIG_HOME}/antigen/antigen.zsh"

# configure_antigen() {
#   autoload -Uz antigeninit
#   record_time "antigen autoload"

#   source "$ANTIGEN_PATH"
#   record_time "antigen config"

#   antigen_packages=(
#     zsh-users/zsh-syntax-highlighting
#     zsh-users/zsh-history-substring-search
#     lukechilds/zsh-better-npm-completion
#   )

#   for package in "${antigen_packages[@]}"; do
#     echo "Installing $package"
#     antigen bundle "$package"
#     record_time "$package"
#   done

#   antigen apply
#   record_time "antigen apply"

#   bindkey '^[[A' history-substring-search-up
#   bindkey '^[[B' history-substring-search-down

#   bindkey -M emacs '^P' history-substring-search-up
#   bindkey -M emacs '^N' history-substring-search-down

#   bindkey -M vicmd 'k' history-substring-search-up
#   bindkey -M vicmd 'j' history-substring-search-down

#   record_time "antigen keybindings"
# }

# if [[ -s "$ANTIGEN_PATH" ]]; then
#   echo "Configuring antigen at $ANTIGEN_PATH"
#   configure_antigen
# else
#   echo "Unable to find antigen path"
# fi
# record_time "antigen load time"
