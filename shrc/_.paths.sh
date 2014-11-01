if $(brew_location="$(type -p "$brew")" && [ -z "$brew_location" ]); then
  # we have homebrew installed
  export PYTHONPATH="$(brew --prefix)/lib/python2.7/site-packages:$PYTHONPATH"
fi

PATH="~/bin:$PATH"
PATH="/usr/local/heroku/bin:$PATH"
PATH="/usr/local/share/npm/bin:$PATH"
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

PATH="/usr/local/mysql/bin:$PATH"
PATH="/usr/local/git/bin:$PATH"
export PATH

MANPATH="/usr/local/man:$MANPATH"
MANPATH="/usr/local/mysql/man:$MANPATH"
MANPATH="/usr/local/git/man:$MANPATH"
export MANPATH

export NODE_PATH="/usr/local/lib/node_modules"

export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
