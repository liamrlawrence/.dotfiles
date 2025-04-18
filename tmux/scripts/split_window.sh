#!/bin/bash
# New panes will activate the first venv found at ./*/bin/activate


if [[ "$1" == "-h" ]]; then
    SPLIT_DIRECTION="-h"
else
    SPLIT_DIRECTION="-v"
fi

PANE_DIR=$(tmux display-message -p -t "${TMUX_PANE}" "#{pane_current_path}")
VENV=$(find "$PANE_DIR" -maxdepth 3 -type f -path "*/bin/activate" | head -n1)

if [[ -n "$VENV" ]]; then
    tmux split-window "$SPLIT_DIRECTION" -c "$PANE_DIR" \
        ". ${VENV}; $SHELL"
else
    tmux split-window "$SPLIT_DIRECTION" -c "$PANE_DIR"
fi

