PATH="~/bin:$PATH"
PATH=".git/safe/../../bin:$PATH"
PATH="/usr/local/heroku/bin:$PATH"
PATH="/usr/local/bin:/usr/local/sbin:$PATH"
PATH="/opt/boxen/bin:/opt/boxen/homebrew/sbin:/opt/boxen/homebrew/bin:$PATH"
PATH="/usr/local/mysql/bin:$PATH"
PATH="/usr/local/git/bin:$PATH"
export PATH

MANPATH="/usr/local/man:$MANPATH"
MANPATH="/usr/local/mysql/man:$MANPATH"
MANPATH="/usr/local/git/man:$MANPATH"
export MANPATH

export NODE_PATH="/usr/local/lib/node_modules"
export GOPATH="$HOME"

if which boot2docker > /dev/null 2>&1
then
  if [[ "$(boot2docker status)" -eq "running" ]]
  then
    export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375
  fi
fi
HOMEBREW_PREFIX="$(brew --prefix)"
export HOMEBREW_PREFIX

if which brew > /dev/null 2>&1
then
  [[ -f ${HOMEBREW_PREFIX}/etc/profile.d/z.sh ]] && source ${HOMEBREW_PREFIX}/etc/profile.d/z.sh

  if [[ -d ${HOMEBREW_PREFIX}/lib/python2.7/ ]]
  then
    export PYTHONPATH="${HOMEBREW_PREFIX}/lib/python2.7/site-packages:$PYTHONPATH"
  fi
fi
