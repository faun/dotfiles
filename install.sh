#!/usr/bin/env bash
# install.sh — run dotfile installation steps with checkpoint tracking
#
# Checkpoints are stored in ~/.local/share/dotfiles/checkpoints/. Each step
# is skipped if it completed successfully and its script has not changed. Delete
# a checkpoint file or pass --force to re-run a step regardless.
#
# Usage:
#   ./install.sh                        run all pending steps
#   ./install.sh <step> [<step>...]     run only the named step(s)
#   ./install.sh --list                 list steps with their status
#   ./install.sh --force                re-run all steps ignoring checkpoints
#   ./install.sh --reset                clear all checkpoints
#
# Each <step> can be a bare name (00_homebrew) or include the .sh extension.
# Steps run in filename order. Set DEBUG=1 for verbose xtrace output.

set -e
shopt -s extglob

cd "$(dirname "$0")" || exit 1
DIR="$PWD"

[[ -n ${DEBUG:-} ]] && set -x

# ---------------------------------------------------------------------------
# Checkpoint helpers
# ---------------------------------------------------------------------------

CHECKPOINT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles/checkpoints"
mkdir -p "$CHECKPOINT_DIR"

_checkpoint_file() { echo "$CHECKPOINT_DIR/$(basename "$1")"; }
_step_hash()       { shasum -a 256 "$1" | awk '{print $1}'; }

_is_done() {
  local cp
  cp="$(_checkpoint_file "$1")"
  [[ -f "$cp" ]] && [[ "$(cat "$cp")" == "$(_step_hash "$1")" ]]
}

_mark_done() { _step_hash "$1" > "$(_checkpoint_file "$1")"; }

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

FORCE=false
LIST=false
RESET=false
SELECTED=()

for arg in "$@"; do
  case "$arg" in
    --force|-f) FORCE=true ;;
    --list|-l)  LIST=true ;;
    --reset)    RESET=true ;;
    --*)        echo "Unknown option: $arg" >&2; exit 1 ;;
    *)          SELECTED+=("$arg") ;;
  esac
done

# ---------------------------------------------------------------------------
# Collect available steps (executable .sh files in install/, sorted)
# ---------------------------------------------------------------------------

ALL_STEPS=()
while IFS= read -r f; do
  ALL_STEPS+=("$f")
done < <(find "$DIR/install" -maxdepth 1 -name "*.sh" -perm +111 | sort)

# ---------------------------------------------------------------------------
# --list: print step names and checkpoint status, then exit
# ---------------------------------------------------------------------------

if $LIST; then
  printf "%-44s %s\n" "Step" "Status"
  printf "%-44s %s\n" "----" "------"
  for f in "${ALL_STEPS[@]}"; do
    if _is_done "$f"; then
      status="done"
    else
      status="pending"
    fi
    printf "%-44s %s\n" "$(basename "$f")" "$status"
  done
  exit 0
fi

# ---------------------------------------------------------------------------
# --reset: clear all checkpoints, then exit
# ---------------------------------------------------------------------------

if $RESET; then
  rm -f "$CHECKPOINT_DIR"/*.sh
  echo "All checkpoints cleared."
  exit 0
fi

# ---------------------------------------------------------------------------
# Resolve the steps to run
# ---------------------------------------------------------------------------

if [[ ${#SELECTED[@]} -gt 0 ]]; then
  STEPS=()
  for name in "${SELECTED[@]}"; do
    found=
    for f in "${ALL_STEPS[@]}"; do
      b="$(basename "$f")"
      if [[ "$b" == "$name" || "$b" == "${name}.sh" ]]; then
        found="$f"
        break
      fi
    done
    if [[ -z "$found" ]]; then
      echo "Unknown step: $name (run --list to see available steps)" >&2
      exit 1
    fi
    STEPS+=("$found")
  done
else
  STEPS=("${ALL_STEPS[@]}")
fi

# ---------------------------------------------------------------------------
# Run steps
# ---------------------------------------------------------------------------

for file in "${STEPS[@]}"; do
  name="$(basename "$file")"
  if ! $FORCE && _is_done "$file"; then
    echo "Skipping $name (already done — use --force to re-run)"
    continue
  fi
  echo "Running $name"
  "$file"
  _mark_done "$file"
done

# ---------------------------------------------------------------------------
# Post-install: neovim spell dictionaries and health check
# ---------------------------------------------------------------------------

echo "Installing spelling dictionaries"
mkdir -p "$HOME/.local/share/nvim/" "$HOME/.vim/spell"
touch "$HOME/.vim/spell/en.utf-8.add"
nvim -u .nvimtest +q

if [[ -z ${SKIP_HEALTH_CHECK:-} ]]; then
  echo "Running checkhealth..."
  HEALTH_LOG="$(mktemp)"
  nvim --headless +checkhealth +"w! $HEALTH_LOG" +qa 2>/dev/null || true

  echo ""
  echo "=== Neovim Health Check Summary ==="

  # Print ERROR lines with context
  errors=$(grep -n "ERROR\|error" "$HEALTH_LOG" 2>/dev/null || true)
  warnings=$(grep -n "WARNING\|warn" "$HEALTH_LOG" 2>/dev/null || true)

  if [[ -n "$errors" ]]; then
    echo ""
    echo "ERRORS:"
    echo "$errors"
  fi

  if [[ -n "$warnings" ]]; then
    echo ""
    echo "WARNINGS:"
    echo "$warnings"
  fi

  if [[ -z "$errors" && -z "$warnings" ]]; then
    echo "All checks passed."
  fi

  echo ""
  echo "Full report saved to: $HEALTH_LOG"
  echo "==================================="

  echo "export SKIP_HEALTH_CHECK=true" >> ~/.local.sh
  export SKIP_HEALTH_CHECK=true
fi

echo "Done."
