if command -v mise >/dev/null 2>&1; then
  SHELL_NAME="$(basename "${SHELL:?}")"
  eval "$(mise activate ${SHELL_NAME:?})"
fi
