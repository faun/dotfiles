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

# Source .profile if it exists
if [[ -f "$HOME/.profile" ]]; then
	source "$HOME/.profile"
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
	curl -sSL 'https://git.io/v5oou' -o "$HOME/.git-prompt.sh" || true
fi
