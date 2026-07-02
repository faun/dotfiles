tmux_attach() {
  if [[ $# -eq 0 ]]; then
    directory_name=$(basename "$PWD")
    session_name=${directory_name//\./_}
    # Attach to the session if it exists, otherwise create it. Running new-session
    # in the foreground (no /dev/null redirect) holds the terminal in both cases;
    # the old `attach … >/dev/null 2>&1` branch returned immediately under a
    # one-shot `ssh -t` remote command and dropped the connection. -D detaches
    # any other client (mirrors the old `attach -d`).
    \tmux -2 new-session -A -D -s "$session_name"
  else
    \tmux -2 "$@"
  fi
}

# zellij, worktree-aware. Sessions are grouped by git checkout: a repo's
# mainline checkout gets one session named after the repo (e.g. `dotfiles`),
# and each linked worktree gets its own `<repo>-<branch>` session (e.g.
# `dotfiles-DATAINFRA-1234`). Worktrees live at <main>/../worktrees/<branch>,
# matching `recent`. Usage:
#
#   zj                       attach/switch to this checkout's session
#   zj <ticket-key>          jump to (or create) that ticket's worktree here
#   zj <repo-path> <key>     jump within another repo
#   zj list-sessions | ...   any zellij subcommand is passed straight through
#
# Ticket keys are matched as a substring of existing worktree/branch names; if
# nothing matches, a worktree is created on a new branch named after the key.

# Sanitize a string into a zellij-safe session name (no dots or slashes).
_zj_sanitize() { printf '%s' "$1" | tr './' '__'; }

# Session name for the current directory's checkout. Outside a git repo, falls
# back to the plain directory basename (the historical behavior).
_zj_session_name() {
  local main_worktree top repo branch
  main_worktree=$(git worktree list --porcelain 2>/dev/null |
    awk '/^worktree /{print substr($0, 10); exit}')
  if [[ -z $main_worktree ]]; then
    _zj_sanitize "$(basename "$PWD")"
    return
  fi
  repo=$(basename "$main_worktree")
  # Compare the current worktree's root against the main one rather than using
  # is_linked_worktree: from a subdirectory git reports --git-dir absolute but
  # --git-common-dir relative, which would misclassify the mainline checkout.
  top=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ $top == "$main_worktree" ]]; then
    _zj_sanitize "$repo"
  else
    branch=$(current_branch)
    _zj_sanitize "${repo}-${branch}"
  fi
}

# Set the terminal tab/window title (best-effort; Ghostty honors OSC 2). This is
# how the session name stays visible — zellij 0.44's built-in bars don't pin it.
_zj_set_title() { printf '\033]2;%s\a' "$1"; }

# Attach (outside zellij) or switch (inside zellij) to a named session, anchored
# in $2 and created on demand.
_zj_switch() {
  local session="$1" cwd="${2:-$PWD}"
  _zj_set_title "$session"
  if [[ -n ${ZELLIJ:-} ]]; then
    # `attach` refuses to nest inside a session, so switch the attached client.
    # `switch-session` won't create a brand-new session, so ensure it exists.
    if ! \zellij list-sessions -s 2>/dev/null | grep -qxF "$session"; then
      (cd "$cwd" && \zellij attach --create-background "$session")
    fi
    \zellij action switch-session --cwd "$cwd" "$session"
  else
    cd "$cwd" && \zellij attach --create "$session"
  fi
}

# Resolve a ticket key to a worktree within a repo, then switch to its session.
_zj_jump() {
  local repo_path="$1" key="$2" main_worktree repo branch worktree_path
  main_worktree=$(git -C "$repo_path" worktree list --porcelain 2>/dev/null |
    awk '/^worktree /{print substr($0, 10); exit}')
  if [[ -z $main_worktree ]]; then
    echo "zj: not a git repository: $repo_path" >&2
    return 1
  fi
  repo=$(basename "$main_worktree")

  # 1) An existing worktree whose branch matches the key wins outright.
  local wt_matches wt_count
  wt_matches=$(git -C "$main_worktree" worktree list --porcelain 2>/dev/null | awk -v k="$key" '
    /^worktree /{p=substr($0, 10)}
    /^branch /{b=$2; sub("refs/heads/", "", b); if (index(tolower(b), tolower(k))) print p"\t"b}
  ')
  wt_count=$(printf '%s\n' "$wt_matches" | grep -c .)

  if [[ $wt_count -eq 1 ]]; then
    worktree_path=$(printf '%s' "$wt_matches" | cut -f1)
    branch=$(printf '%s' "$wt_matches" | cut -f2)
  elif [[ $wt_count -gt 1 ]]; then
    local pick
    pick=$(printf '%s\n' "$wt_matches" | fzf --with-nth=2 --delimiter='\t') || return 1
    worktree_path=$(printf '%s' "$pick" | cut -f1)
    branch=$(printf '%s' "$pick" | cut -f2)
  else
    # 2) A local branch with no worktree yet, else 3) a brand-new branch = key.
    local br_matches br_count
    br_matches=$(git -C "$main_worktree" for-each-ref --format='%(refname:short)' refs/heads/ |
      awk -v k="$key" '{ if (index(tolower($0), tolower(k))) print }')
    br_count=$(printf '%s\n' "$br_matches" | grep -c .)
    if [[ $br_count -eq 1 ]]; then
      branch=$br_matches
    elif [[ $br_count -gt 1 ]]; then
      branch=$(printf '%s\n' "$br_matches" | fzf) || return 1
    else
      branch=$key
    fi
    worktree_path="$main_worktree/../worktrees/$branch"
    if [[ ! -d $worktree_path ]]; then
      if git -C "$main_worktree" show-ref --verify --quiet "refs/heads/$branch"; then
        git -C "$main_worktree" worktree add "$worktree_path" "$branch" || return 1
      else
        git -C "$main_worktree" worktree add -b "$branch" "$worktree_path" || return 1
      fi
    fi
  fi

  worktree_path=$(cd "$worktree_path" && pwd) || return 1
  _zj_switch "$(_zj_sanitize "${repo}-${branch}")" "$worktree_path"
}

zellij_attach() {
  # No args: attach/switch to the current checkout's session.
  if [[ $# -eq 0 ]]; then
    _zj_switch "$(_zj_session_name)" "$PWD"
    return
  fi

  # An explicit zellij subcommand or flag is passed straight through.
  case "$1" in
    -* | options | setup | list-sessions | ls | attach | a | \
      kill-session | k | delete-session | kill-all-sessions | ka | \
      delete-all-sessions | action | run | r | plugin | edit | e | \
      convert-config | convert-layout | convert-theme | pipe | web)
      \zellij "$@"
      return
      ;;
  esac

  # Otherwise treat it as a jump: `zj [<repo-path>] <ticket-key>`.
  if [[ $# -ge 2 && -d "$1" ]]; then
    _zj_jump "$1" "$2"
  else
    _zj_jump "$PWD" "$1"
  fi
}

# mkdir, cd into it
mkcd() {
  mkdir -p "$*"
  cd "$*"
}

# Trash files
function trash() {
  local dir
  for dir in "$@"; do
    # ignore any arguments
    if [[ "$dir" = -* ]]; then
      :
    else
      local dst=${dir##*/}
      # append the time if necessary
      while [ -e ~/.Trash/"$dst" ]; do
        dst="$dst "$(date +%H-%M-%S)
      done
      mv "$dir" ~/.Trash/"$dst"
    fi
  done
}

# build html from markdown, optimized for legibility on mobile devices
function mdbuild() {
  read -d '' head <<"EOF"
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv=Content-type content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width">
  <title></title>
</head>
<body>
EOF
  local foot="</body>\n</html>\n"
  for input in "$@"; do
    out=${input%.*}.html
    echo $head >$out
    markdown $input | smartypants >>$out
    echo $foot >>$out
  done
}

# run a command multiple times
function dotimes() {
  if [[ $# -lt 2 ]]; then
    echo "usage: dotimes number-of-times command-to-run"
    return 1
  fi
  local max=$1
  local i=0
  local fails=0
  shift
  while [ $i -lt $max ]; do
    i=$(expr $i + 1)
    "$@"
    echo -n "\n#### "
    if [[ $? -gt 0 ]]; then
      echo -n "FAILED"
      fails=$(expr $fails + 1)
    else
      echo -n "PASSED"
    fi
    echo -n " ($i/$max, $fails fails)"
    echo -n " ####\n\n"
  done
  echo "\n\n#### $fails out of $max runs failed. ####\n"
}

# See http://brettterpstra.com/2013/07/24/bash-image-tools-for-web-designers/
# Quickly get image dimensions from the command line
function imgsize() {
  local width height
  if [[ -f $1 ]]; then
    height=$(sips -g pixelHeight "$1" | tail -n 1 | awk '{print $2}')
    width=$(sips -g pixelWidth "$1" | tail -n 1 | awk '{print $2}')
    echo "${width} x ${height}"
  else
    echo "File not found"
  fi
}
#
# encode a given image file as base64 and output css background property to clipboard
function 64enc() {
  openssl base64 -in $1 | awk -v ext="${1#*.}" '{ str1=str1 $0 }END{ print "background:url(data:image/"ext";base64,"str1");" }' | pbcopy
  echo "$1 encoded to clipboard"
}

function 64font() {
  openssl base64 -in $1 | awk -v ext="${1#*.}" '{ str1=str1 $0 }END{ print "src:url(\"data:font/"ext";base64,"str1"\")  format(\"woff\");" }' | pbcopy
  echo "$1 encoded as font and copied to clipboard"
}

function show_colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
  done
}

man() {
  env \
    LESS_TERMCAP_md=$'\e[1;36m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[7;33;33m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[1;32m' \
    man "$@"
}

ppid() { ps -p "${1:-$$}" -o ppid=; }
