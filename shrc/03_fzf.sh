# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--bind ctrl-f:page-down,ctrl-b:page-up'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --path-to-ignore ~/.ignore -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Use ag instead of the default find command for listing candidates.
# - The first argument to the function is the base path to start traversal
# - Note that ag only lists files not directories
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  ag -g "" "$1"
}

record_time "fzf"
