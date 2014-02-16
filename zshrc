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
[[ -f $HOME/.localrc ]] && . $HOME/.localrc

# Add bin directory to path
if [ -d $HOME/bin ]; then
 export PATH="$HOME/bin:$PATH"
fi

plugins=(git rails brew bundler)

source $ZSH/oh-my-zsh.sh

for file in $HOME/.shrc/*.sh; do
  source "$file"
done

source $HOME/.zsh/aliases
source $HOME/.zsh/completion
source $HOME/.zsh/config

# enable rvm if it exists
if [ -d $HOME/.rvm ]; then
  export PATH=$HOME/.rvm/bin:$PATH
  export rvm_path="$HOME/.rvm"
  [[ -s $rvm_path/scripts/rvm ]] && source $rvm_path/scripts/rvm
fi

# otherwise use rbenv

if [ -d $HOME/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
fi
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
  export RBENV_ROOT=$HOME/.rbenv
fi

source $HOME/.zsh/faunzy.zsh-theme
