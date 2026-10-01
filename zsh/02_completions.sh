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

# Add Homebrew paths if they exist and have the right permissions.
# HOMEBREW_PREFIX is already exported by shrc/00_paths.sh, which sources first.
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  if [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]]; then
    if compaudit "$HOMEBREW_PREFIX/share/zsh-completions" >/dev/null 2>&1; then
      fpath=(
        "$HOMEBREW_PREFIX/share/zsh-completions"
        $fpath
      )
    fi
  fi
fi

# Cached tool completions.
#
# Asking a tool to print its own zsh completion costs 70-140ms, and these used
# to be regenerated on every shell. Writing the output into an fpath directory
# lets compinit autoload each one on first use instead, and it is rebuilt only
# when the tool binary is newer than its cache. Each tool here emits a
# "#compdef <tool>" header, which is what makes lazy autoload work.
_completion_cache_dir="$HOME/.zsh/functions/completions"
_completion_cache_stale=0

_completion_cache_build() {
  local tool="$1" bin cache
  bin=$(command -v "$tool" 2>/dev/null) || return 0
  [[ -n "$bin" ]] || return 0
  cache="$_completion_cache_dir/_$tool"
  [[ -s "$cache" && ! "$bin" -nt "$cache" ]] && return 0
  if "$tool" completion zsh >"$cache.new" 2>/dev/null && [[ -s "$cache.new" ]]; then
    mv -f "$cache.new" "$cache"
    _completion_cache_stale=1
  else
    rm -f "$cache.new"
  fi
}

[[ -d "$_completion_cache_dir" ]] || mkdir -p "$_completion_cache_dir"
for _tool in "${(@s: :)ZSH_COMPLETION_CACHE_TOOLS:-kubectl helm docker devspace database}"; do
  _completion_cache_build "$_tool"
done
unset _tool

# The completion cache directory is on fpath, so compinit picks each file up
# lazily. The dump has to be rebuilt when a cache file changes, otherwise the
# new completion stays invisible until the next full compinit.
autoload -Uz compinit
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if (( _completion_cache_stale )); then
  rm -f "$_zcompdump"
  compinit -d "$_zcompdump"
elif [[ -n $_zcompdump(#qN.mh+24) ]]; then
  # Older than a day: run the full security audit.
  compinit -d "$_zcompdump"
else
  # Audited today already; trust the dump.
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump _completion_cache_stale _completion_cache_dir
unfunction _completion_cache_build

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

# The k alias borrows kubectl's completion instead of generating a rewritten
# copy of the whole script.
(( $+commands[kubectl] )) && compdef k=kubectl

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
[[ -d ~/.zsh_cache ]] || mkdir -p ~/.zsh_cache

zstyle ':completion:*:complete:(cd|pushd):*' tag-order \
  'local-directories named-directories'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %d

zstyle ':completion:*:descriptions' format %B%d%b        # bold
zstyle ':completion:*:descriptions' format %F{green}%d%f # green foreground
