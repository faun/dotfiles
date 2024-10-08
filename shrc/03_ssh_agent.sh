SSH_ENV="$HOME/.ssh/environment"

function start_agent {
	/usr/bin/ssh-agent | sed 's/^echo/#echo/' >"${SSH_ENV}"
	chmod 600 "${SSH_ENV}"
	source "${SSH_ENV}" >/dev/null
	ssh-add -A &>/dev/null || ssh-add -l
}

if [[ -n "$SSH_AUTH_SOCK" ]]; then
	killall ssh-agent &>/dev/null || true
elif [[ -d "$HOME/.ssh" ]]; then
	# Source SSH settings, if applicable

	if [ -f "${SSH_ENV}" ]; then
		source "${SSH_ENV}" >/dev/null
		ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ >/dev/null || {
			start_agent
		}
	else
		start_agent
	fi
fi
