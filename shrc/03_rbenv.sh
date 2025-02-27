if [[ "${USE_RBENV:-false}" != "false" ]]; then
  # Add rbenv to PATH if it's not already there
  if [[ -z $RBENV_SHELL ]]; then
    RBENV_ROOT="${RBENV_ROOT:-$HOME/.rbenv}"

    PATH="$RBENV_ROOT/bin:$PATH"

    if command -v rbenv >/dev/null 2>&1; then
      eval "$(rbenv init -)"
    fi
  fi
fi
