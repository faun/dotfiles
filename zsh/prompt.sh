autoload -U promptinit && promptinit
setopt prompt_subst
autoload -U colors && colors

if [ -r "${HOMEBREW_PREFIX}/etc/bash_completion.d/git-prompt.sh" ]; then
  # shellcheck source=/usr/local/etc/bash_completion.d/git-prompt.sh
  source "${HOMEBREW_PREFIX}/etc/bash_completion.d/git-prompt.sh"
fi

ZSH_THEME_GIT_PROMPT_PREFIX=" ("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"

function git_prompt_info() {
  if command -v __git_ps1 >/dev/null 2>&1; then
    local dirty
    dirty="$(parse_git_dirty)"
    __git_ps1 "${ZSH_THEME_GIT_PROMPT_PREFIX//\%/%%}%s${dirty//\%/%%}${ZSH_THEME_GIT_PROMPT_SUFFIX//\%/%%}"
  fi
}
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{${reset_color}%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{${reset_color}%}"
PURE_GIT_UNTRACKED_DIRTY=0

# One git invocation per prompt draw, not two: `status` already fails outside a
# work tree, so its exit status stands in for the `rev-parse` check this used to
# make first. --ignore-submodules is here for speed, not just output noise;
# without it git recurses into every submodule, which measured 4.1s against
# 0.3s in a repo with 20 of them.
parse_git_dirty() {
  local umode porcelain
  [[ "$PURE_GIT_UNTRACKED_DIRTY" == 0 ]] && umode="-uno" || umode="-unormal"
  porcelain="$(command git status --porcelain --ignore-submodules "$umode" 2>/dev/null)" || return
  if [[ -n "$porcelain" ]]; then
    print -r -- "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    print -r -- "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

KUBE_PS1_SCRIPT_PATH="${HOMEBREW_PREFIX}/opt/kube-ps1/share/kube-ps1.sh"

if [[ -s "$KUBE_PS1_SCRIPT_PATH" ]]; then
  # shellcheck disable=SC1090
  source "$KUBE_PS1_SCRIPT_PATH"
  # shellcheck disable=SC2016
  kubeps1=' $(kube_ps1)'
else
  kubeps1=""
fi

# Based off the murilasso zsh theme
user_host='%{$fg[green]%}%n@%m%{$reset_color%}'
# %~ is expanded by zsh itself; $(pwd -P) forked a subshell on every draw.
current_dir='%{$fg[blue]%}%~%{$reset_color%}'
git_branch='$(git_prompt_info)'

# shellcheck disable=1087
export PROMPT="${user_host}:${current_dir}${git_branch} ${kubeps1}
❯ "
# shellcheck disable=1087
export SUDO_PS1="$fg[green]\u@\h:$fg[blue]\w
$fg[red] \\$ $reset_color"
