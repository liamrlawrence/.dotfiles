#!/bin/bash
# New panes will activate the first venv where ./*/pyvenv.cfg exists


if [[ "$1" == "-h" ]]; then
    SPLIT_DIRECTION="-h"
else
    SPLIT_DIRECTION="-v"
fi

PANE_DIR=$(tmux display-message -p -t "${TMUX_PANE}" "#{pane_current_path}")
VENV_CFG=$(find "$PANE_DIR" -maxdepth 2 -type f -name "pyvenv.cfg" | head -n1)

if [[ -n "$VENV_CFG" ]]; then
    VENV="${VENV_CFG%/pyvenv.cfg}/bin/activate"
    tmux split-window "$SPLIT_DIRECTION" -c "$PANE_DIR" \
        ". ${VENV}; $SHELL"
else
    tmux split-window "$SPLIT_DIRECTION" -c "$PANE_DIR"
fi

