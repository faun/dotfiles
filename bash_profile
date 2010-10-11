echo "=> Loading `pwd`/bash_profile"
source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config

# Add bin directory to path
if [ -d ~/bin ]; then
 export PATH=:~/bin:$PATH
fi

# Load in .bashrc
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi


# Enable RVM
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm


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