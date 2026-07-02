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

print "\n$_pass passed, $_fail failed"
(( _fail == 0 ))
