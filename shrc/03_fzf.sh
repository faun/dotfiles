#!/usr/bin/env bash

# FZF
# shellcheck disable=1090
if [[ $SHELL =~ /zsh$/ ]]; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
elif [[ $SHELL =~ /bash$/ ]]; then
  [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color fg:-1,bg:-1,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B'

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'
export FZF_PREVIEW_COMMAND="bat --style=numbers --color=always {}"
export FZF_PREVIEW_PREVIEW_BAT_THEME='Nord'

# Use ag instead of the default find command for listing candidates.
# - The first argument to the function is the base path to start traversal
# - Note that ag only lists files not directories
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  ag -g "" "$1"
}
