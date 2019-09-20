[[ "$(command -v git)" ]] || return
if [[ -n $ZSH_NAME ]]
then
  zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash
fi
record_time "git autocompletions"
