#!/usr/bin/env bash

HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
export HOMEBREW_PREFIX
record_time "homebrew prefix"
