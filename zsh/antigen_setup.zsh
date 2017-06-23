autoload -Uz antigeninit
record_time "antigen autoload"
source $HOME/.config/antigen/antigen.zsh
record_time "antigen config"

antigen_packages=(
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-completions
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search
)

for package in $antigen_packages
do
  antigen bundle "$package"
  record_time "$package"
done

antigen apply
record_time "antigen apply"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
