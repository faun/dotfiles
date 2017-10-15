SSH_ENV="$HOME/.ssh/environment"

function start_agent {
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
  source "${SSH_ENV}" > /dev/null
  # Note this only works on macOS Sierra +
  ssh-add -K ~/.ssh/id_rsa &> /dev/null
  ssh-add -A &> /dev/null
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
  source "${SSH_ENV}" > /dev/null
  #ps ${SSH_AGENT_PID} doesn't work under cywgin
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
  start_agent;
}
else
  start_agent;
fi
