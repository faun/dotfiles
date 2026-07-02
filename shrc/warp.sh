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
