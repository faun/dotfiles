if [[ -d "$HOME/.local/bin" ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# Shims mode on purpose: this is the only mise activation a non-interactive
# login shell ever sees, because those never read zshrc. Interactive shells
# skip it and switch to hook-env in shrc/05_mise.sh, which resolves
# per-project mise.toml files on cd; generating shims here just to strip them
# back off PATH there is wasted work.
if ! [[ -o interactive ]] && [[ "${USE_MISE:-true}" != "false" ]] && command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh --shims)"
fi

# No `gh auth status` guard: it is a round trip to the GitHub API, while
# `gh auth token` reads the local keyring and prints nothing when unauthenticated.
#
# Wrapped in a function so noxtrace has a scope to be local to: the token must
# not reach `set -x` output, or tracing startup writes a live credential to disk.
_gh_export_token() {
  setopt localoptions noxtrace
  local token
  token="$(gh auth token 2>/dev/null)" || return 0
  [[ -n "$token" ]] && export GITHUB_TOKEN="$token"
}
if command -v gh >/dev/null 2>&1; then
  _gh_export_token
fi
unset -f _gh_export_token 2>/dev/null
