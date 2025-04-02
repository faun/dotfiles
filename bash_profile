#!/usr/bin/env bash
for file in "$HOME"/.shrc/*.sh; do
  . "$file"
done

# Load in .bashrc
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1

# ls colors, see: http://www.linux-sxs.org/housekeeping/lscolors.html
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90'

# Ignore duplicate entries in bash history
export HISTCONTROL=ignoredups

# After each command, checks the windows size and changes lines and columns
shopt -s checkwinsize

# Autocorrect misspelled directories
shopt -s cdspell

unset MAILCHECK
# Turn on advanced bash completion if the file exists (get it here: http://www.caliban.org/bash/index.shtml#completion)
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Disable flow control commands (keeps C-s from freezing everything)
if [ -t 0 ] && [ -t 1 ]; then
  stty start undef
  stty stop undef
fi

shopt -s cdable_vars # set the bash option so that no '$' is required when using the above facility

export PS1="→ "
export PS2='>' # Secondary prompt
export PS3='?' # Prompt 3
export PS4='+' # Prompt 4

# RVM really wants this to be here, even though it's defined elsewhere. So let's make RVM happy
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
