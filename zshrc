# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

plugins=(git rails brew bundler zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Source shell-agnostic config files
for file in $HOME/.shrc/*.sh; do
  source "$file"
done

# Source zsh-specific files
for file in $HOME/.zsh/*.sh; do
  source "$file"
done

# Base16 Shell
BASE16_SHELL="$HOME/.base16-shell/base16-tomorrow.dark.sh"
[[ -s $BASE16_SHELL ]] && . $BASE16_SHELL

source $HOME/.zsh/faunzy.zsh-theme
