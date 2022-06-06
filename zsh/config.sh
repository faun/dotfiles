if [[ "$SHELL" =~ zsh ]]
then

  if [[ -n $SSH_CONNECTION ]]; then
    export PS1='%m:%3~$(git_info_for_prompt)%# '
  else
    export PS1='%3~$(git_info_for_prompt)%# '
  fi
  record_time "zsh prompt"

  fpath=(~/.zsh/functions $fpath)
  autoload -U ~/.zsh/functions/*(:t)

  if command -v brew 1>/dev/null 2>&1
  then
    homebrew_zsh_completion=$(brew --prefix)/share/zsh/functions
    fpath=($homebrew_zsh_completion $fpath)
  fi

  HISTFILE=~/.zsh_history
  HISTSIZE=1000000
  SAVEHIST=$HISTSIZE

  setopt histignorealldups sharehistory

  zstyle ':completion:*:complete:(cd|pushd):*' tag-order \
      'local-directories named-directories'
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*:descriptions' format %d

  zstyle ':completion:*:descriptions' format %B%d%b        # bold
  zstyle ':completion:*:descriptions' format %F{green}%d%f # green foreground

  setopt NO_BG_NICE # don't nice background tasks
  setopt NO_HUP
  setopt NO_LIST_BEEP
  setopt LOCAL_OPTIONS # allow functions to have local options
  setopt LOCAL_TRAPS # allow functions to have local traps

  # Whenever the user enters a line with history expansion, don’t execute the
  # line directly; instead, perform history expansion and reload the line into
  # the editing buffer.
  setopt HIST_VERIFY

  # If set, parameter expansion, command substitution and arithmetic expansion
  # are performed in prompts. Substitutions within prompts do not affect the
  # command status.
  setopt PROMPT_SUBST

  # setopt CORRECT
  # Try to correct the spelling of commands. Note that, when the HASH_LIST_ALL
  # option is not set or when some directories in the path are not readable, this
  # may falsely report spelling errors the first time some commands are used.

  # The shell variable CORRECT_IGNORE may be set to a pattern to match words that
  # will never be offered as corrections.
  setopt CORRECT

  # If unset, the cursor is set to the end of the word if completion is started.
  # Otherwise it stays there and completion is done from both ends.
  setopt COMPLETE_IN_WORD

  # Make cd push the old directory onto the directory stack
  setopt AUTO_PUSHD

  # Do not print the directory stack after pushd or popd
  setopt PUSHD_SILENT

  # Don’t push multiple copies of the same directory onto the directory stack.
  setopt PUSHD_IGNORE_DUPS

  # Don't confirm an rm *
  setopt RMSTARSILENT

  # set the option so that no '$' is required when using the save function
  setopt CDABLE_VARS

  # Command history
  setopt APPEND_HISTORY # adds history

  # New history lines are added to the $HISTFILE incrementally (as soon as they
  # are entered), rather than waiting until the shell exits
  setopt INC_APPEND_HISTORY

  # Add timestamps to history
  setopt EXTENDED_HISTORY

  # Don't record duplicate entries in the history file
  setopt HIST_IGNORE_ALL_DUPS

  # Remove superfluous blanks from each command line being added to the history
  # list
  setopt HIST_REDUCE_BLANKS

  # Prevent a command from being recorded into history by preceding it with at
  # least one space.
  setopt hist_ignore_space

  # If a pattern for filename generation has no matches, do not print an error,
  # instead, leave it unchanged in the argument list.
  unsetopt nomatch

  zle -N newtab

  # Make sure that the terminal is in application mode when zle is active, since
  # only then values from $terminfo are valid
  if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init() {
      echoti smkx
    }
    function zle-line-finish() {
      echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
  fi

  # Stolen from:
  # https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/key-bindings.zsh

  bindkey -e                                            # Use emacs key bindings

  bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
  if [[ "${terminfo[kpp]}" != "" ]]; then
    bindkey "${terminfo[kpp]}" up-line-or-history       # [PageUp] - Up a line of history
  fi
  if [[ "${terminfo[knp]}" != "" ]]; then
    bindkey "${terminfo[knp]}" down-line-or-history     # [PageDown] - Down a line of history
  fi

  if [[ "${terminfo[khome]}" != "" ]]; then
    bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
  fi
  if [[ "${terminfo[kend]}" != "" ]]; then
    bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
  fi

  bindkey ' ' magic-space                               # [Space] - do history expansion

  if [[ "${terminfo[kcbt]}" != "" ]]; then
    bindkey "${terminfo[kcbt]}" reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
  fi

  bindkey '^?' backward-delete-char                     # [Backspace] - delete backward
  if [[ "${terminfo[kdch1]}" != "" ]]; then
    bindkey "${terminfo[kdch1]}" delete-char            # [Delete] - delete forward
  else
    bindkey "^[[3~" delete-char
    bindkey "^[3;5~" delete-char
    bindkey "\e[3~" delete-char
  fi

  # file rename magick
  bindkey "^[m" copy-prev-shell-word

  bindkey '^[^[[D' backward-word
  bindkey '^[^[[C' forward-word
  bindkey '^[b' backward-word
  bindkey '^[w' forward-word
  bindkey '^[[5D' beginning-of-line
  bindkey '^[[5C' end-of-line
  bindkey '^[[3~' delete-char
  bindkey '^[^N' newtab
  bindkey '^?' backward-delete-char
  bindkey '^O' clear-screen

  record_time "zsh keybinding"

  # Set screen titles to last run command
  setopt extended_glob
  preexec () {
    if [[ "$TERM" == "screen" ]]; then
      local CMD=${1[(wr)^(*=*|sudo|-*)]}
      echo -ne "\ek$CMD\e\\"
    fi
  }

  alias help="man zshbuiltins"
  record_time "zsh config"
  alias reload="reset && source $HOME/.zshrc"

fi
