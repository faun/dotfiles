#echo "=> Loading `pwd`/bash_profile"

source $HOME/.anyshell/paths
source $HOME/.anyshell/functions
source $HOME/.anyshell/aliases
source $HOME/.bash/aliases
source $HOME/.bash/completions
source $HOME/.bash/paths
source $HOME/.bash/config

# Add bin directory to path
if [ -d $HOME/bin ]; then
 export PATH="$HOME/bin:$PATH"
fi

# Load in .bashrc
if [ -f $HOME/.bashrc ]; then
  . $HOME/.bashrc
fi
source $HOME/.bash/colors
source $HOME/.bash/prompt

export rvm_path="$HOME/.rvm"
# Enable RVM
[[ -s $rvm_path/scripts/rvm ]] && source $rvm_path/scripts/rvm
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

# Notes: ----------------------------------------------------------
# When you start an interactive shell (log in, open terminal or iTerm in OS X, 
# or create a new tab in iTerm) the following files are read and run, in this order:
#     profile
#     bashrc
#     .bash_profile
#     .bashrc (only because this file is run (sourced) in .bash_profile)
#
# When an interactive shell, that is not a login shell, is started 
# (when you run "bash" from inside a shell, or when you start a shell in 
# xwindows [xterm/gnome-terminal/etc] ) the following files are read and executed, 
# in this order:
#     bashrc
#     .bashrc
