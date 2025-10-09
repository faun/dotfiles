#!/usr/bin/env bash

# Custom tmux session switcher that orders sessions by most recent activity
current_session=$(tmux display-message -p "#{session_name}")
session=$(tmux list-sessions -F "#{session_activity} #{session_name}" | \
          sort -rn | \
          awk '{print $2}' | \
          grep -v "^${current_session}$" | \
          fzf --reverse)

if [ -n "$session" ]; then
    tmux switch-client -t "$session"
fi