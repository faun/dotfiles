# Set PYENV_ROOT to ~/.pyenv unless it exists
if [[ "x$PYENV_ROOT" == "x" ]]
then
  export PYENV_ROOT=$HOME/.pyenv
fi
record_time "pyenv paths"

if [ -d "$PYENV_ROOT" ]; then
  if command -v pyenv > /dev/null 2>&1
  then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
fi
record_time "pyenv initialization"

