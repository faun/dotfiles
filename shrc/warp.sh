#!/usr/bin/env bash
# warp — locate & navigate to a worktree by PR or Jira ticket. See
# docs/superpowers/specs/2026-07-01-warp-locate-navigate-design.md.

# Parse an input string into "TYPE<TAB>REPO<TAB>SELECTOR".
_warp_parse() {
  emulate -L zsh
  local in="$1"
  in="${in#"${in%%[![:space:]]*}"}"   # ltrim
  in="${in%"${in##*[![:space:]]}"}"    # rtrim
  if [[ "$in" =~ 'github\.com/([^/]+)/([^/]+)/pull/([0-9]+)' ]]; then
    printf 'pr\t%s/%s\t%s\n' "$match[1]" "$match[2]" "$match[3]"
  elif [[ "$in" =~ 'atlassian\.net/browse/([A-Za-z]+-[0-9]+)' ]]; then
    printf 'ticket\t\t%s\n' "${match[1]:l}"
  elif [[ "$in" =~ '^([A-Za-z][A-Za-z0-9_.-]*[A-Za-z0-9])[[:space:]]*#([0-9]+)$' ]]; then
    printf 'pr\t%s\t%s\n' "$match[1]" "$match[2]"
  elif [[ "$in" =~ '^[A-Za-z]+-[0-9]+$' ]]; then
    printf 'ticket\t\t%s\n' "${in:l}"
  else
    printf 'unknown\t\t%s\n' "$in"
  fi
}

# Absolute path of the repo checkout named $1 under $WARP_SRC.
_warp_repo_path() {
  emulate -L zsh
  local name="$1" root="${WARP_SRC:-$HOME/src}"
  local -a hits
  hits=("${(@f)$(find "$root" -maxdepth 5 -type d -name "$name" \
    -not -path '*/worktrees/*' -not -path '*/.git/*' 2>/dev/null)}")
  hits=(${hits:#})
  case ${#hits} in
    0) return 1 ;;
    1) print -r -- "$hits[1]" ;;
    *) print -rl -- $hits | fzf || return 1 ;;
  esac
}

# fzf over every repo under $WARP_SRC; prints the chosen checkout path.
_warp_pick_repo() {
  emulate -L zsh
  local root="${WARP_SRC:-$HOME/src}"
  find "$root" -maxdepth 5 -type d -name .git 2>/dev/null | sed 's#/\.git$##' | fzf
}

# Worktree path checked out on $2 within repo $1 (empty if none).
_warp_worktree_for_branch() {
  emulate -L zsh
  command git -C "$1" worktree list --porcelain 2>/dev/null | awk -v b="$2" '
    /^worktree /{p=substr($0,10)}
    /^branch /{wb=$2; sub("refs/heads/","",wb); if (wb==b) {print p; exit}}'
}

# For every repo with worktrees under $WARP_SRC, emit repo\tbranch\tpath
# for worktrees whose branch contains $1 (case-insensitive).
_warp_worktree_candidates() {
  emulate -L zsh
  local key="$1" root="${WARP_SRC:-$HOME/src}" wt repo
  local -a dirs
  dirs=("${(@f)$(find "$root" -maxdepth 6 -type d -path '*/.git/worktrees' 2>/dev/null)}")
  for wt in ${dirs:#}; do
    repo="${wt%/.git/worktrees}"
    command git -C "$repo" worktree list --porcelain 2>/dev/null | awk -v k="$key" -v r="$repo" '
      /^worktree /{p=substr($0,10)}
      /^branch /{b=$2; sub("refs/heads/","",b);
                 if (index(tolower(b),tolower(k))) printf "%s\t%s\t%s\n", r, b, p}'
  done
}

# Head branch of PR #$2 in repo $1, via gh (run inside the repo).
_warp_pr_branch() {
  emulate -L zsh
  ( cd "$1" && command gh pr view "$2" --json headRefName -q .headRefName )
}

# Resolve (TYPE REPO SELECTOR) -> "repo_path\tbranch\tworktree_path".
_warp_resolve() {
  emulate -L zsh
  local type="$1" repo="$2" sel="$3" repo_path branch wt
  case "$type" in
    pr)
      repo_path="$(_warp_repo_path "${repo##*/}")" \
        || { print "warp: repo not found: ${repo##*/}" >&2; return 1; }
      branch="$(_warp_pr_branch "$repo_path" "$sel")" \
        || { print "warp: gh could not resolve PR $sel" >&2; return 1; }
      [[ -z "$branch" ]] && { print "warp: PR $sel has no head branch" >&2; return 1; }
      wt="$(_warp_worktree_for_branch "$repo_path" "$branch")"
      printf '%s\t%s\t%s\n' "$repo_path" "$branch" "$wt"
      ;;
    ticket)
      local -a cands
      cands=("${(@f)$(_warp_worktree_candidates "$sel")}")
      cands=(${cands:#})
      case ${#cands} in
        0) printf '\t%s\t\n' "$sel" ;;
        1) print -r -- "$cands[1]" ;;
        *) print -rl -- $cands | fzf --delimiter='\t' --with-nth=2,1 || return 1 ;;
      esac
      ;;
    *) return 1 ;;
  esac
}

# First tmux pane whose CWD is $1 -> "session\twindow.pane" (empty if none).
_warp_find_tmux() {
  emulate -L zsh
  local -a T; T=(command tmux)
  [[ -n "$WARP_TMUX_SOCKET" ]] && T+=(-L "$WARP_TMUX_SOCKET")
  [[ -n "$WARP_TMUX_ARGS" ]] && T+=(${=WARP_TMUX_ARGS})
  "$T[@]" list-panes -a \
    -F '#{pane_current_path}	#{session_name}	#{window_index}.#{pane_index}' 2>/dev/null \
    | awk -F'\t' -v p="$1" '$1==p {print $2"\t"$3; exit}'
}

# Focus tmux session $1 window.pane $2, raising the hosting Ghostty tab when the
# session is attached to a different client.
_warp_focus_tmux() {
  emulate -L zsh
  local sess="$1" wp="$2"
  local -a T; T=(command tmux)
  [[ -n "$WARP_TMUX_SOCKET" ]] && T+=(-L "$WARP_TMUX_SOCKET")
  [[ -n "$WARP_TMUX_ARGS" ]] && T+=(${=WARP_TMUX_ARGS})
  "$T[@]" select-window -t "${sess}:${wp%.*}" 2>/dev/null
  "$T[@]" select-pane   -t "${sess}:${wp}"    2>/dev/null
  local clients; clients="$("$T[@]" list-clients -t "$sess" -F '#{client_tty}' 2>/dev/null)"
  if [[ -n "$TMUX" ]]; then
    if [[ -n "$clients" ]] && ! print -r -- "$clients" | grep -qxF -- "$(tty)"; then
      _warp_ax_raise "$sess" || "$T[@]" switch-client -t "$sess"
    else
      "$T[@]" switch-client -t "$sess"
    fi
  else
    if [[ -n "$clients" ]]; then
      _warp_ax_raise "$sess"
    else
      "$T[@]" attach -t "$sess"
    fi
  fi
}

# Raise the Ghostty tab whose title contains $1. 0 = raised, non-zero otherwise.
_warp_ax_raise() {
  emulate -L zsh
  local res
  res="$(osascript - "$1" <<'APPLESCRIPT'
on run argv
  set needle to item 1 of argv
  tell application "System Events"
    if not (exists process "Ghostty") then return "no-ghostty"
    tell process "Ghostty"
      repeat with w in windows
        try
          repeat with tg in (tab groups of w)
            repeat with rb in (radio buttons of tg)
              if (name of rb) contains needle then
                set frontmost to true
                perform action "AXRaise" of w
                perform action "AXPress" of rb
                return "ok"
              end if
            end repeat
          end repeat
        end try
      end repeat
    end tell
  end tell
  return "no-match"
end run
APPLESCRIPT
)"
  [[ "$res" == "ok" ]]
}

_warp_zellij_sessions() { command zellij list-sessions -s 2>/dev/null; }

# Session matching $1-$2 (sanitized), or one containing $2; empty if none.
_warp_find_zellij() {
  emulate -L zsh
  local want; want="$(_zj_sanitize "$1-$2")"
  if _warp_zellij_sessions | grep -qxF -- "$want"; then
    print -r -- "$want"; return 0
  fi
  _warp_zellij_sessions | grep -iF -- "$2" | head -1
}

warp() {
  emulate -L zsh
  local dry=0
  [[ "$1" == -n || "$1" == --dry-run ]] && { dry=1; shift; }
  if [[ -z "$1" ]]; then
    print "usage: warp [-n|--dry-run] <pr-url | repo #num | JIRA-KEY | jira-url>" >&2
    return 1
  fi

  local _parsed; _parsed="$(_warp_parse "$1")"
  local type="${_parsed%%	*}"
  local _rest="${_parsed#*	}"
  local repo="${_rest%%	*}"
  local sel="${_rest#*	}"
  if [[ "$type" == unknown ]]; then
    print "warp: unrecognized input: $1" >&2; return 1
  fi

  local _resolved; _resolved="$(_warp_resolve "$type" "$repo" "$sel")" || return 1
  local repo_path="${_resolved%%	*}"
  local _rest2="${_resolved#*	}"
  local branch="${_rest2%%	*}"
  local wt="${_rest2#*	}"

  (( dry )) && print "type=$type repo=${repo_path:-?} branch=$branch worktree=${wt:-<none>}"

  # Open on disk: try tmux, then zellij, else open via zj.
  if [[ -n "$wt" ]]; then
    local tm; tm="$(_warp_find_tmux "$wt")"
    if [[ -n "$tm" ]]; then
      local s="${tm%%	*}" w="${tm#*	}"
      (( dry )) && { print "action: focus tmux $s:$w"; return 0; }
      _warp_focus_tmux "$s" "$w"; return
    fi
    local zs; zs="$(_warp_find_zellij "${repo_path:t}" "$branch")"
    if [[ -n "$zs" ]]; then
      (( dry )) && { print "action: focus zellij session $zs"; return 0; }
      _warp_ax_raise "$zs" || command zellij attach "$zs"; return
    fi
    (( dry )) && { print "action: zj $repo_path $branch (open existing worktree)"; return 0; }
    zj "$repo_path" "$branch"; return
  fi

  # Not created yet.
  if [[ -z "$repo_path" ]]; then
    (( dry )) && { print "action: prompt for repo, then zj <repo> $branch"; return 0; }
    repo_path="$(_warp_pick_repo)" || return 1
  fi
  (( dry )) && { print "action: zj $repo_path $branch (create)"; return 0; }
  zj "$repo_path" "$branch"
}
