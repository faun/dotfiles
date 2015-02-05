PATH="~/bin:$PATH"
PATH=".git/safe/../../bin:$PATH"
PATH="/usr/local/heroku/bin:$PATH"
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

PATH="/usr/local/mysql/bin:$PATH"
PATH="/usr/local/git/bin:$PATH"
export PATH

MANPATH="/usr/local/man:$MANPATH"
MANPATH="/usr/local/mysql/man:$MANPATH"
MANPATH="/usr/local/git/man:$MANPATH"
export MANPATH

export NODE_PATH="/usr/local/lib/node_modules"
export GOPATH="$HOME"
export PATH=$PATH:$GOPATH/bin

if which boot2docker > /dev/null 2>&1
then
  if [[ "$(boot2docker status)" -eq "running" ]]
  then
    export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375
  fi
fi

if which brew > /dev/null 2>&1
then
  echo "homebrew installed"
  export BREW_BIN="`brew --prefix`/bin:$PATH"
  [[ -f `brew --prefix`/etc/profile.d/z.sh ]] && source `brew --prefix`/etc/profile.d/z.sh

  if [[ -d $(brew --prefix)/lib/python2.7/ ]]
  then
    export PYTHONPATH="$(brew --prefix)/lib/python2.7/site-packages:$PYTHONPATH"
  fi
fi
