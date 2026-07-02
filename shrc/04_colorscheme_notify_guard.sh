#!/usr/bin/env bash
# Guard against stray terminal color-scheme reports leaking onto the prompt.
#
# DEC private mode 2031 lets a program subscribe to light/dark theme-change
# notifications; the terminal then answers each change with "CSI ?997;{1,2}n"
# (;1 dark, ;2 light). A TUI that enables 2031 but exits — or is backgrounded —
# without sending "CSI ?2031l" leaves the subscription live, so the next OS
# theme flip delivers that report to whatever now owns the terminal. At a bare
# shell that means the bytes get echoed and "997;..n" is dropped onto the
# command line, where it can corrupt the next command.
#
# Two complementary defenses, because the report can arrive at two different
# moments relative to the prompt:
#
#   1. Unsubscribe (CSI ?2031l) before drawing each prompt, so a subscription
#      left behind by an exited TUI is cleared while the shell is idle. Programs
#      that actually want the notifications re-enable the mode when they start,
#      so this only affects the idle prompt. (The reset itself lives in
#      functions.sh so warp/zj can reuse it at their session-switch boundary.)
#
#   2. Swallow a report that still reaches an already-idle prompt — e.g. a theme
#      flip, or a focus/tab change (warp raising a Ghostty tab) that makes the
#      terminal re-report to a surface that is still subscribed. precmd already
#      ran, so unsubscribing can't help; instead teach the line editor to
#      consume the two fixed report sequences as a no-op rather than letting the
#      bytes self-insert. This only matches those exact sequences, so it can't
#      eat real typed input.
if [[ -n "${ZSH_VERSION:-}" ]]; then
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _reset_colorscheme_notifications   # defined in functions.sh

  if [[ -o interactive ]]; then
    _swallow_colorscheme_report() { true; }
    zle -N _swallow_colorscheme_report
    bindkey '\e[?997;1n' _swallow_colorscheme_report   # dark
    bindkey '\e[?997;2n' _swallow_colorscheme_report   # light
  fi
fi
