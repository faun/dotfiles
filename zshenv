# `ssh host cmd` (and mosh, which Moshi uses to launch herdr) runs a
# non-interactive, non-login zsh: it reads only this file, never zprofile or
# zshrc, so ~/.local/bin and mise tools are missing and `herdr: not found`.
#
# Login shells get the same entries from zprofile, and interactive shells get
# hook-env from shrc/05_mise.sh, so only the bare `zsh -c` case is handled here.
if ! [[ -o interactive || -o login ]]; then
  [[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
  [[ -d "$HOME/.local/share/mise/shims" ]] && PATH="$HOME/.local/share/mise/shims:$PATH"
  export PATH
fi
