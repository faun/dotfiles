#!/usr/bin/env bash
# The single interactive mise activation.
#
# zprofile activates mise in shims mode, which is what non-interactive login
# shells get, since they never read this directory. Interactive shells want
# hook-env instead: it re-resolves tools on every prompt, so a per-project
# mise.toml takes effect on cd. The two modes both want to own the same
# commands, so the shims directory comes off PATH before hook-env activates.
#
# This file is numbered to sort late in ~/.shrc/* on purpose. mise wants to
# activate after everything else has finished editing PATH.
#
# MISE_MODE=shim keeps shims and skips hook-env. USE_MISE=false skips mise.

if [[ "${USE_MISE:-true}" != "false" ]] && command -v mise >/dev/null 2>&1; then
  MISE_MODE="${MISE_MODE:-hook}"

  # The running shell, not $SHELL. bash_profile sources this directory too, and
  # $SHELL names the login shell rather than the interpreter reading the file,
  # so a bash session under a zsh login shell would otherwise eval zsh syntax.
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    _mise_shell=zsh
  elif [[ -n "${BASH_VERSION:-}" ]]; then
    _mise_shell=bash
  fi

  if [[ -n "${_mise_shell:-}" ]]; then
    if [[ "${MISE_MODE}" == "shim" ]]; then
      eval "$(mise activate "${_mise_shell}" --shims)"
    else
      # Drop the shims directory zprofile added, so lookups resolve through
      # hook-env's per-project tool directories instead of the shims.
      #
      # Walking PATH one colon-delimited field at a time, rather than
      # substituting separators, keeps this identical under bash and zsh: zsh
      # does not expand $'\n' in the replacement half of ${var//pat/repl} and
      # would splice the literal characters into PATH.
      _mise_shims="$HOME/.local/share/mise/shims"
      _mise_path=""
      _mise_rest="$PATH"
      while [[ -n "$_mise_rest" ]]; do
        _mise_entry="${_mise_rest%%:*}"
        if [[ "$_mise_rest" == *:* ]]; then
          _mise_rest="${_mise_rest#*:}"
        else
          _mise_rest=""
        fi

        [[ -z "$_mise_entry" ]] && continue
        [[ "$_mise_entry" == "$_mise_shims" ]] && continue
        _mise_path="${_mise_path:+$_mise_path:}$_mise_entry"
      done
      PATH="$_mise_path"
      export PATH
      unset _mise_shims _mise_path _mise_rest _mise_entry

      eval "$(mise activate "${_mise_shell}")"
    fi
  fi

  unset _mise_shell
fi
