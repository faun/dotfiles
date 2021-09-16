#!/usr/bin/env bash

export COLORTERM="truecolor"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=${HOME}/.config}"

BASE16_SHELL_PATH="${XDG_CONFIG_HOME}/base16-shell"

# Load profile helpers
[ -n "$PS1" ] && [ -s "${BASE16_SHELL_PATH}/profile_helper.sh" ] && eval "$("${BASE16_SHELL_PATH}/profile_helper.sh")"
record_time "base16-profile-helper"

# Load base16-shell
# shellcheck disable=1091
source "${BASE16_SHELL_PATH}/scripts/base16-twilight.sh"

record_time "base16-shell"
