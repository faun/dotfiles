[ "$(command -v git)" ] || return
if [ -n "$ZSH_NAME" ]; then
  if [ -r /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
    zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-prompt.sh
  fi
  # shellcheck disable=SC1072,SC2039,SC2206
  fpath=(~/.zsh $fpath)
fi
record_time "git autocompletions"
