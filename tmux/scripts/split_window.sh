#!/bin/bash
# Wrapper around tmux split-window; passes all args through.
# New panes will activate the first venv where ./*/pyvenv.cfg exists

PANE_DIR=$(tmux display-message -p -t "${TMUX_PANE}" "#{pane_current_path}")
VENV_CFG=$(find "$PANE_DIR" -maxdepth 2 -type f -name "pyvenv.cfg" | head -n1)

if [[ -n "$VENV_CFG" ]]; then
    VENV="${VENV_CFG%/pyvenv.cfg}/bin/activate"
    tmux split-window -c "$PANE_DIR" -e "ACTIVATE_VENV=${VENV}" "$@"
else
    tmux split-window -c "$PANE_DIR" "$@"
fi

