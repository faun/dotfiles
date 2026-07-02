#!/usr/bin/env zsh
emulate -L zsh
setopt no_unset
DOT="${0:A:h}/.."
source "$DOT/shrc/functions.sh"
source "$DOT/shrc/git.sh"
source "$DOT/shrc/warp.sh"

typeset -gi _pass=0 _fail=0
assert_eq() {  # assert_eq desc expected actual
  if [[ "$2" == "$3" ]]; then
    print "  ok: $1"; (( _pass++ ))
  else
    print "  FAIL: $1"; print "    expected: [$2]"; print "    actual:   [$3]"; (( _fail++ ))
  fi
}

print "== _warp_parse =="
assert_eq "pr url"        $'pr\tGusto/terraform\t30466' \
  "$(_warp_parse 'https://github.com/Gusto/terraform/pull/30466')"
assert_eq "pr short space" $'pr\tterraform\t30466' "$(_warp_parse 'terraform #30466')"
assert_eq "pr short tight" $'pr\tterraform\t30466' "$(_warp_parse 'terraform#30466')"
assert_eq "ticket upper"   $'ticket\t\tdatainfra-2092' "$(_warp_parse 'DATAINFRA-2092')"
assert_eq "ticket lower"   $'ticket\t\tdatainfra-2092' "$(_warp_parse 'datainfra-2092')"
assert_eq "ticket url"     $'ticket\t\tdatainfra-2092' \
  "$(_warp_parse 'https://gustohq.atlassian.net/browse/DATAINFRA-2092')"
assert_eq "unknown"        $'unknown\t\trandom words' "$(_warp_parse 'random words')"

print "\n== _warp_repo_path =="
_wtmp=$(mktemp -d)
mkdir -p "$_wtmp/github.com/Gusto/terraform" "$_wtmp/github.com/faun/dotfiles"
mkdir -p "$_wtmp/github.com/Gusto/worktrees/terraform"   # decoy: must be ignored
WARP_SRC="$_wtmp" assert_eq "unique repo" "$_wtmp/github.com/Gusto/terraform" \
  "$(WARP_SRC="$_wtmp" _warp_repo_path terraform)"
WARP_SRC="$_wtmp" _warp_repo_path nonesuch >/dev/null 2>&1
assert_eq "missing repo -> nonzero" "1" "$?"
rm -rf "$_wtmp"

print "\n== worktree lookup =="
_wtmp=$(mktemp -d); _wtmp=$(cd "$_wtmp" && pwd -P)
mkdir -p "$_wtmp/github.com/Gusto"
_repo="$_wtmp/github.com/Gusto/database-cli"
command git init -q "$_repo"; ( cd "$_repo"
  git config user.email t@t; git config user.name t
  echo x > a; git add a; git commit -qm init
  git worktree add -q ../worktrees/datainfra-2092 -b datainfra-2092 >/dev/null )
assert_eq "worktree for branch" "$_wtmp/github.com/Gusto/worktrees/datainfra-2092" \
  "$(cd "$_repo" && _warp_worktree_for_branch "$_repo" datainfra-2092)"
assert_eq "candidates by key" \
  $''"$_repo"$'\tdatainfra-2092\t'"$_wtmp/github.com/Gusto/worktrees/datainfra-2092" \
  "$(WARP_SRC="$_wtmp" _warp_worktree_candidates 2092)"
rm -rf "$_wtmp"

print "\n== _warp_resolve =="
_wtmp=$(mktemp -d); mkdir -p "$_wtmp/github.com/Gusto"
_repo="$_wtmp/github.com/Gusto/terraform"
command git init -q "$_repo"; ( cd "$_repo"
  git config user.email t@t; git config user.name t
  echo x > a; git add a; git commit -qm init
  git branch feat-30466 )
# stub gh lookup
_warp_pr_branch() { print -r -- "feat-30466"; }
assert_eq "resolve pr -> repo/branch/empty-wt" \
  $''"$_repo"$'\tfeat-30466\t' \
  "$(WARP_SRC="$_wtmp" _warp_resolve pr terraform 30466)"
assert_eq "resolve ticket not open" $'\tdatainfra-9999\t' \
  "$(WARP_SRC="$_wtmp" _warp_resolve ticket '' datainfra-9999)"
unfunction _warp_pr_branch   # restore real one for later
rm -rf "$_wtmp"

print "\n$_pass passed, $_fail failed"
(( _fail == 0 ))
