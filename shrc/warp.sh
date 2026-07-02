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
