RBENV_ROOT="${RBENV_ROOT:-$HOME/.rbenv}"
if [ -d "$RBENV_ROOT" ]; then
	PATH="${RBENV_ROOT:?}/bin:$PATH"
fi
export RBENV_ROOT

if command -v rbenv >/dev/null; then
	eval "$(rbenv init -)"
fi
