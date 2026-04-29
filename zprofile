if [[ -d "$HOME/.local/bin" ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh --shims)"
fi

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  export GITHUB_TOKEN="$(gh auth token)"
fi
