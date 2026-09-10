if [[ -d "$HOME/.local/bin" ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# Shims mode on purpose: this is the only mise activation a non-interactive
# login shell ever sees, because those never read zshrc. Interactive shells
# drop these shims and switch to hook-env in shrc/05_mise.sh, which resolves
# per-project mise.toml files on cd.
if [[ "${USE_MISE:-true}" != "false" ]] && command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh --shims)"
fi

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  export GITHUB_TOKEN="$(gh auth token)"
fi
