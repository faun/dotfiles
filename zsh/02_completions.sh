# Add paths in order of priority
fpath=(
  "$HOME/.zsh/functions"
  "$HOME/.zsh/functions/completions"
  "$HOME/.zfunc"
  $fpath
)

# Add "/usr/share/zsh/$ZSH_VERSION/functions" to fpath if it exists and
# has the right permissions
if [[ -d "/usr/share/zsh/$ZSH_VERSION/functions" ]]; then
  if compaudit "/usr/share/zsh/$ZSH_VERSION/functions" >/dev/null 2>&1; then
    fpath=(
      "/usr/share/zsh/$ZSH_VERSION/functions"
      $fpath
    )
  fi
fi

# Add Homebrew paths if they exist and have the right permissions
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
  if [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]]; then
    if compaudit "$HOMEBREW_PREFIX/share/zsh-completions" >/dev/null 2>&1; then
      fpath=(
        "$HOMEBREW_PREFIX/share/zsh-completions"
        $fpath
      )
    fi
  fi
fi

autoload -Uz compinit
compinit

# git
compdef _git got=git
compdef _git get=git

# git status
compdef _git gs=git-status
compdef _git g=git-status

# git pull
compdef _git glf=git-pull
compdef _git glr=git-pull

# git add
compdef _git gap=git-add
compdef _git gaa=git-add
compdef _git ga=git-add

# git clone
compdef _git gcl=git-clone

# git commit
compdef _git gcm=git-commit
compdef _git gcam=git-commit

# git diff
compdef _git gdc=git-diff

# git branch
compdef _git gb=git-branch

autoload -U +X bashcompinit && bashcompinit

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ignore completions that begin with an '_' for command and default completions
zstyle ':completion:*:*:-command-:*:*' ignored-patterns '_*'
zstyle ':completion:*:default:*:*:*:*' ignored-patterns '_*'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

#Fuzzy matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Disable disable username completions for 'cd' and 'pushd'
zstyle ':completion:*:cd:*' users ""
zstyle ':completion:*:pushd:*' users ""

#Use cache for completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache

zstyle ':completion:*:complete:(cd|pushd):*' tag-order \
  'local-directories named-directories'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %d

zstyle ':completion:*:descriptions' format %B%d%b        # bold
zstyle ':completion:*:descriptions' format %F{green}%d%f # green foreground

# tenv completion
if [[ -f $HOME/.tenv.completion.zsh ]]; then
  source $HOME/.tenv.completion.zsh
fi
