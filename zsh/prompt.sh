autoload -U promptinit && promptinit
setopt prompt_subst
autoload -U colors && colors

record_time "autoload prompt"

if [ -r "${HOMEBREW_PREFIX}/etc/bash_completion.d/git-prompt.sh" ]; then
  # shellcheck source=/usr/local/etc/bash_completion.d/git-prompt.sh
  source "${HOMEBREW_PREFIX}/etc/bash_completion.d/git-prompt.sh"
fi

record_time "source git prompt"

# show current rbenv version if different from rbenv global
ruby_version_status() {
  if which rbenv >/dev/null; then
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
  if command -v __git_ps1 >/dev/null 2>&1; then
    dirty="$(parse_git_dirty)"
    __git_ps1 "${ZSH_THEME_GIT_PROMPT_PREFIX//\%/%%}%s${dirty//\%/%%}${ZSH_THEME_GIT_PROMPT_SUFFIX//\%/%%}"
  fi
}
record_time "git prompt info"

parse_git_dirty() {
  [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || return
  [[ "$PURE_GIT_UNTRACKED_DIRTY" == 0 ]] && local umode="-uno" || local umode="-unormal"
  command test -n "$(git status --porcelain --ignore-submodules ${umode})"
  (($? == 0)) && echo $ZSH_THEME_GIT_PROMPT_DIRTY || echo $ZSH_THEME_GIT_PROMPT_CLEAN
}
record_time "git dirty checking"

node_version_prompt() {
  if type node >/dev/null; then
    echo "[$(node -v | sed 's/^v//')]"
  fi
}

record_time "nvm prompt"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
pyenv_virtualenv_version() {
  if command -v pyenv >/dev/null 2>&1; then
    [ -z "$PYENV_VIRTUALENV_GLOBAL_NAME" ] && export PYENV_VIRTUALENV_GLOBAL_NAME="$(pyenv global)"
    VENV_NAME="$(pyenv version-name)"
    VENV_NAME="${VENV_NAME##*/}"

    echo -e "($VENV_NAME)"
  fi
}
pyenv_version="$(pyenv_virtualenv_version)"
record_time "pyenv_virtualenv prompt"

KUBE_PS1_SCRIPT_PATH="${HOMEBREW_PREFIX}/opt/kube-ps1/share/kube-ps1.sh"

if [[ -s "$KUBE_PS1_SCRIPT_PATH" ]]; then
  # shellcheck disable=SC1090
  source "$KUBE_PS1_SCRIPT_PATH"
  # shellcheck disable=SC2016
  kubeps1=' $(kube_ps1)'
else
  kubeps1=""
fi

record_time "kube-ps1 prompt"

# Based off the murilasso zsh theme

return_code='%(?..%{$fg[red]%}%? ↵%{$reset_color%})'
user_host='%{$fg[green]%}%n@%m%{$reset_color%}'
current_dir='%{$fg[blue]%}$(pwd -P)%{$reset_color%}'
ruby_version='%{$fg[red]%}$(ruby_version_status)%{$reset_color%}'
git_branch='%{$fg[blue]%}$(git_prompt_info)%{$reset_color%}'
node_version=' %{$fg[blue]%}$(node_version_prompt)%{$reset_color%}'
py_version=' %{$fg[yellow]%}${pyenv_version}%{${reset_color}%}'

# shellcheck disable=1087
export PROMPT="${user_host}:${current_dir} ${ruby_version}${node_version}${py_version}${kubeps1}
%{$fg[blue]%}${git_branch} %B$%b "
export RPS1="${return_code}"
# shellcheck disable=1087
export SUDO_PS1="$fg[green]\u@\h:$fg[blue]\w
$fg[red] \\$ $reset_color"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
record_time "setting prompt"
