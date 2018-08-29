if command -v pyenv 1>/dev/null 2>&1
then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  record_time "pyenv initialzation"
fi
