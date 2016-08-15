autoload -U promptinit && promptinit
setopt prompt_subst
autoload -U colors && colors

dir=$(dirname $0)
source ${dir}/../shrc/git-prompt.sh
record_time "source git-prompt"

# show current rbenv version if different from rbenv global
ruby_version_status() {
  if which rbenv > /dev/null; then
    local ver=$(rbenv version-name)
    if [ "$(rbenv global)" != "$ver" ]; then
      echo "[$ver]"
    else
      # mark the ruby version as implicit
      echo "($ver)"
    fi
  else
    [ -e "$HOME/.rvm/bin/rvm-prompt" ] && echo "$($HOME/.rvm/bin/rvm-prompt i v p g s)"
  fi
}
record_time "ruby prompt"

function git_prompt_info() {
  dirty="$(parse_git_dirty)"
  __git_ps1 "${ZSH_THEME_GIT_PROMPT_PREFIX//\%/%%}%s${dirty//\%/%%}${ZSH_THEME_GIT_PROMPT_SUFFIX//\%/%%}"
}
record_time "git prompt info"

parse_git_dirty() {
  [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || return
  [[ "$PURE_GIT_UNTRACKED_DIRTY" == 0 ]] && local umode="-uno" || local umode="-unormal"
  command test -n "$(git status --porcelain --ignore-submodules ${umode})"
  (($? == 0)) && echo $ZSH_THEME_GIT_PROMPT_DIRTY || echo $ZSH_THEME_GIT_PROMPT_CLEAN
}
record_time "git dirty checking"
# Based off the murilasso zsh theme

return_code='%(?..%{$fg[red]%}%? ↵%{$reset_color%})'
user_host='%{$fg[green]%}%n@%m%{$reset_color%}'
current_dir='%{$fg[blue]%}$(pwd -P)%{$reset_color%}'
ruby_version='%{$fg[red]%}$(ruby_version_status)%{$reset_color%}'
git_branch='%{$fg[blue]%}$(git_prompt_info)%{$reset_color%}'

export PROMPT="${user_host}:${current_dir} ${ruby_version}
%{$fg[blue]%}${git_branch} %B$%b "
export RPS1="${return_code}"
export SUDO_PS1="$fg[green]\u@\h:$fg[blue]\w
$fg[red] \\$ $reset_color"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
record_time "setting prompt"
