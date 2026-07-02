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
