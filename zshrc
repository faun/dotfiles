if [ -f $HOME/.anyshell/paths ]; then
  source $HOME/.anyshell/paths
fi

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh
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

# use .localrc for settings specific to one system
[[ -f $HOME/.localrc ]] && .  $HOME/.localrc

# Autojump

if [[ `uname` == 'Darwin' ]]; then
  [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
  autoload -U compinit && compinit
fi

# Add bin directory to path
if [ -d $HOME/bin ]; then
 export PATH="$HOME/bin:$PATH"
fi

# Enable RVM
export rvm_path="$HOME/.rvm"

[[ -s $rvm_path/scripts/rvm ]] && source $rvm_path/scripts/rvm

__rvm_project_rvmrc

plugins=(git rails rails3 svn textmate compleat ruby pow osx gem brew bundler cap git-flow zsh-syntax-highlighting nyan)

source $ZSH/oh-my-zsh.sh

source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $HOME/.anyshell/functions
source $HOME/.anyshell/aliases
source $HOME/.zsh/aliases
source $HOME/.zsh/completion
source $HOME/.zsh/config

source $HOME/.zsh/faunzy.zsh-theme

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# export ZSH_THEME="random"

export PATH=$HOME/node_modules/.bin/lessc:$PATH
export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
