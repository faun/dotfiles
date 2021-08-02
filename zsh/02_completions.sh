fpath=("$HOME/.zsh/functions/completions" $fpath)
fpath=("/usr/share/zsh/5.3/functions" $fpath)
fpath=("/usr/share/zsh/$ZSH_VERSION/functions/" $fpath)
fpath=("$HOME/.zfunc" $fpath)

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload -Uz compinit
compinit

autoload -U +X bashcompinit && bashcompinit

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ignore completions that begin with an '_'
zstyle ':completion:*:*:-command-:*:*' ignored-patterns '_*'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

#Fuzzy matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

#Use cache for completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache

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
