# Ensure correct locale
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export EDITOR='nvim'
[ "$TMUX" = "" ] && export TERM=xterm-256color

# Load optional platform-specific configuration
if [[ "$OSTYPE" == linux* ]]; then
  alias a='ls -lrth --color'
  alias ls='ls --color=auto'
elif [[ "$OSTYPE" == darwin* ]]; then
  SHELL_TYPE="$(basename "$SHELL")"
  if [[ $SHELL_TYPE == 'bash' ]]; then
    CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  else
    CURRENT_DIR=$(dirname "$0")
  fi
  alias a='ls -lrthG'
  alias ls='ls -G'
  [[ -f $CURRENT_DIR/optional/macos.sh ]] && source "$CURRENT_DIR"/optional/macos.sh
fi

# Source .gpg-agent-info if it exists
if [[ -f "$HOME/.gpg-agent-info" ]]; then
  source "$HOME/.gpg-agent-info"
  GPG_TTY="$(tty)"
  export GPG_TTY
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
  export SSH_AGENT_PID
fi

if [[ -f "$HOME/.git-prompt.sh" ]]; then
  source "$HOME/.git-prompt.sh"
else
  # Fetch straight from the canonical source rather than the git.io shortlink
  # (git.io is a GitHub redirect service that occasionally 503s, and plain
  # curl -o would happily cache that error page as if it were the script).
  # -f makes curl fail on HTTP errors instead of writing the error body, and
  # downloading to a tmpfile first keeps a failed fetch from leaving a
  # corrupt/partial file that a later shell would try to source.
  tmp="$(mktemp)"
  if curl -sSL -f 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh' -o "$tmp"; then
    mv "$tmp" "$HOME/.git-prompt.sh"
  else
    rm -f "$tmp"
  fi
fi

if [[ -n "$TMUX" ]] && [[ "$SHLVL" -eq 2 ]]; then
  # If we are in a tmux session, reattach to it
  # This enables using touch ID for sudo in
  # tmux sessions
  # See:
  # - https://github.com/fabianishere/pam_reattach
  # - https://github.com/artginzburg/sudo-touchid
  if command -v reattach-to-session-namespace &>/dev/null; then
    reattach-to-session-namespace -u "$(id -u)" "$SHELL"
  fi
fi
