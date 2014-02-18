# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Add bin directory to path
if [ -d $HOME/bin ]; then
 export PATH="$HOME/bin:$PATH"
fi

plugins=(git rails brew bundler)

source $ZSH/oh-my-zsh.sh

# Source shell-agnostic config files
for file in $HOME/.shrc/*.sh; do
  source "$file"
done

# Source zsh-specific files
for file in $HOME/.zsh/*.sh; do
  source "$file"
done

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
