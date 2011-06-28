# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
export ZSH_THEME="murilasso"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rails rails3 vi-mode rvm svn ssh-agent git ruby osx gem homebrew bundler cap git-flow)

source $ZSH/oh-my-zsh.sh

source $HOME/.zsh/aliases
source $HOME/.zsh/completion
source $HOME/.zsh/config
source $HOME/.zsh/paths

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && .  ~/.localrc

# Add bin directory to path
if [ -d ~/bin ]; then
 export PATH="~/bin:$PATH"
fi

# Enable RVM
export rvm_path="$HOME/.rvm"

[[ -s $rvm_path/scripts/rvm ]] && source $rvm_path/scripts/rvm

__rvm_project_rvmrc

source ~/.oh-my-zsh/oh-my-zsh.sh 
