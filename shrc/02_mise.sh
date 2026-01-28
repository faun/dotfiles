#!/usr/bin/env bash

if [[ "${USE_MISE}:-true" != "false" ]]; then
  MISE_MODE="${MISE_MODE:-shim}"

  if command -v mise >/dev/null 2>&1; then
    SHELL_NAME="$(basename "${SHELL:?}")"

    if [[ "${MISE_MODE}" == "shim" ]]; then
      # shellcheck disable=SC2155
      export PATH=$(
        echo "$PATH" |
          sed -e 's/[^\:]*\/.local\/share\/mise\/shims//' |
          sed -e 's/::/:/' |
          sed -e 's/^://' | sed -e 's/:$//'
      )
      eval "$(mise activate ${SHELL_NAME:?} --shims)"
    else
      eval "$(mise activate ${SHELL_NAME:?})"
    fi
  fi
fi
