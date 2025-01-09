if [[ -d "$HOME/.local/bin" ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if command -v mise >/dev/null 2>&1; then
  mise activate zsh --shims

  if [[ -d "$HOME/.local/share/mise/shims" ]]; then
    PATH="$HOME/.local/share/mise/shims:$PATH"
    export PATH
  fi
fi
