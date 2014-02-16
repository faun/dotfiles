for file in $HOME/.shrc/*.sh; do
  . "$file"
done

# Load in .bashrc
if [ -f $HOME/.bashrc ]; then
  . $HOME/.bashrc
fi

export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1

# ls colors, see: http://www.linux-sxs.org/housekeeping/lscolors.html
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90'

# Ignore duplicate entries in bash history
export HISTCONTROL=ignoredups

# After each command, checks the windows size and changes lines and columns
shopt -s checkwinsize 

# Autocorrect mispelled directories
shopt -s cdspell

# bash completion settings (actually, these are readline settings)
bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
bind "set bell-style none"
bind "set show-all-if-ambiguous On"
unset MAILCHECK
# Turn on advanced bash completion if the file exists (get it here: http://www.caliban.org/bash/index.shtml#completion)
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Disable flow control commands (keeps C-s from freezing everything)
stty start undef
stty stop undef

shopt -s cdable_vars # set the bash option so that no '$' is required when using the above facility

export PS1="→ "
export PS2='>'   # Secondary prompt
export PS3='?'   # Prompt 3
export PS4='+'   # Prompt 4
