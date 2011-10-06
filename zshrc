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
[[ -f ~/.localrc ]] && .  ~/.localrc

# Add bin directory to path
if [ -d ~/bin ]; then
 export PATH="~/bin:$PATH"
fi

# Enable RVM
export rvm_path="$HOME/.rvm"

[[ -s $rvm_path/scripts/rvm ]] && source $rvm_path/scripts/rvm

__rvm_project_rvmrc

mvim()
{
  (unset GEM_PATH GEM_HOME; command mvim "$@")
}

source $ZSH/oh-my-zsh.sh

source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
plugins=(git rails rails3 rvm svn compleat git ruby pow osx gem brew bundler cap git-flow zsh-syntax-highlighting)

source $HOME/.zsh/aliases
source $HOME/.zsh/completion
source $HOME/.zsh/config
source $HOME/.zsh/paths

# override default rvm_prompt_info
function rvm_prompt_info() {
  ruby_version=$(~/.rvm/bin/rvm-prompt i v p 2> /dev/null)
  if [[ -n $ruby_version ]]; then
    echo "($ruby_version)"
  else
    echo "(system)"
  fi
}

source $HOME/.zsh/faunzy.zsh-theme

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# export ZSH_THEME="random"
