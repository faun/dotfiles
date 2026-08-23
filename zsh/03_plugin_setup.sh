#!/usr/bin/env bash
# shellcheck disable=SC1090

configure_antidote() {

  source <(antidote init)

  ANTIDOTE_PACKAGES="$(
    cat <<EOF
		zsh-users/zsh-syntax-highlighting
		zsh-users/zsh-autosuggestions
		zsh-users/zsh-history-substring-search
		lukechilds/zsh-better-npm-completion
EOF
  )"
  ANTIDOTE_PLUGINS_PATH="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
  if ! [[ -f "${ANTIDOTE_PLUGINS_PATH:?}" ]]; then
    echo "${ANTIDOTE_PACKAGES:?}" >"${ANTIDOTE_PLUGINS_PATH:?}"
  fi
  # Generate the static plugin file ourselves rather than relying on `antidote load`.
  #
  # `source <(antidote init)` above installs a wrapper function that special-cases `bundle` to
  # SOURCE its output instead of printing it. Through that wrapper the load path produced an
  # empty ~/.zsh_plugins.zsh, and antidote only regenerates when the .txt is newer than the
  # .zsh — both had identical mtimes from that first run, so it stayed empty permanently. No
  # plugins loaded, so the bindkey below pointed at a widget that did not exist and every
  # up-arrow press printed "No such widget: history-substring-search-up".
  #
  # `zsh -f` starts without any of this config, so antidote there is the real function and
  # prints the fpath+=/source lines as intended.
  local zsh_plugins_static="${ANTIDOTE_PLUGINS_PATH%.txt}.zsh"
  if [[ ! -s "$zsh_plugins_static" || "${ANTIDOTE_PLUGINS_PATH}" -nt "$zsh_plugins_static" ]]; then
    zsh -f -c "source ${ANTIDOTE_PATH}/antidote.zsh; antidote bundle < ${ANTIDOTE_PLUGINS_PATH}" \
      >"$zsh_plugins_static" || true
  fi
  [[ -s "$zsh_plugins_static" ]] && source "$zsh_plugins_static"

  # Bind against named keymaps, never the main one. zsh/config.sh runs `bindkey -e` after this
  # file (glob order sorts config.sh after 03_*), and that swaps the main keymap for a fresh
  # emacs copy, silently discarding anything bound here without -M. That is why Ctrl-P/Ctrl-N
  # kept working while the arrows reverted to up-line-or-history.
  #
  # Guarded on the widget existing, so a future plugin-load failure degrades to plain arrow
  # keys plus one warning rather than an error on every keypress.
  if (( ${+widgets[history-substring-search-up]} )); then
    local km
    for km in emacs viins; do
      bindkey -M "$km" '^[[A' history-substring-search-up
      bindkey -M "$km" '^[[B' history-substring-search-down
      bindkey -M "$km" '^[OA' history-substring-search-up    # application cursor mode
      bindkey -M "$km" '^[OB' history-substring-search-down
    done

    bindkey -M emacs '^P' history-substring-search-up
    bindkey -M emacs '^N' history-substring-search-down

    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
  else
    print -u2 "warning: zsh-history-substring-search did not load; arrow keys left at defaults."
    print -u2 "         Try: rm -f ${zsh_plugins_static} && exec zsh"
  fi

}

ANTIDOTE_PATH="${ZDOTDIR:-$HOME}/.antidote"
if ! [[ -d "$ANTIDOTE_PATH" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "${ANTIDOTE_PATH:?}" || true
fi

if [[ -d "${ANTIDOTE_PATH:?}" ]]; then
  source "${ANTIDOTE_PATH:?}/antidote.zsh"
fi

alias antigen="antidote"

if command -v antidote >/dev/null 2>&1; then
  configure_antidote
else
  echo "Couldn't find antidote binary"
fi
