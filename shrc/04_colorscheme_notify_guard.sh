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
# Nothing at an interactive prompt consumes those reports, so unsubscribe before
# drawing each prompt. Programs that actually want the notifications re-enable
# the mode when they start, so this only affects the idle prompt.
if [[ -n "${ZSH_VERSION:-}" ]]; then
  autoload -Uz add-zsh-hook
  _reset_colorscheme_notifications() { [[ -t 1 ]] && printf '\033[?2031l'; }
  add-zsh-hook precmd _reset_colorscheme_notifications
fi
