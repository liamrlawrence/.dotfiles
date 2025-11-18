#!/bin/bash


set -euo pipefail

if [ -z "${TMUX-}" ]; then
    echo "This script must be run inside a tmux session." >&2
    exit 1
fi

if [ $# -lt 2 ] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Usage: $0 {left|right} command [args...]" >&2
    echo "Example: $0 right htop" >&2
    exit 1
fi

direction="$1"
direction="${direction,,}"  # to lowercase
if [[ "$direction" != "left" && "$direction" != "right" ]]; then
    echo "First argument must be 'left' or 'right'." >&2
    exit 1
fi

shift 1
if [ $# -eq 0 ]; then
    echo "You must provide a command to run after the direction." >&2
    exit 1
fi
cmd="$*"


if [ "$direction" = "right" ]; then
    # largest pane_right
    target_pane="$(
        tmux list-panes -F '#{pane_id} #{pane_right}' \
        | sort -nk2 \
        | awk 'END {print $1}'
    )"
else
    # smallest pane_left
    target_pane="$(
        tmux list-panes -F '#{pane_id} #{pane_left}' \
        | sort -nk2 \
        | awk 'NR == 1 {print $1}'
    )"
fi


tmux send-keys -t "$target_pane" "$cmd" C-m

