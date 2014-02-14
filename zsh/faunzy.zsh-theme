# show current rbenv version if different from rbenv global
rbenv_version_status() {
  if which rbenv > /dev/null; then
    local ver=$(rbenv version-name)
    echo "[$(rbenv global)]"
  fi
}
#Based off the murilasso zsh theme
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local user_host='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}'
local current_dir='%{$fg[blue]%}$(pwd -P)%{$reset_color%}'
local ruby_version='%{$fg[red]%}$(rbenv_version_status)%{$reset_color%}'
local git_branch='%{$fg[blue]%}$(git_prompt_info)%{$reset_color%}'

PROMPT="${user_host}:${current_dir} ${ruby_version}
%{$fg[blue]%}${git_branch} %B$%b "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
