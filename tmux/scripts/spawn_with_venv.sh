#!/bin/bash
# Wrapper around tmux commands that spawn a process (split-window, new-window,
# new-session...). Passes remaining args through.
#
# Looks for a venv in the pane's current directory and, if found, exports
# ACTIVATE_VENV into the new process for the shell rc to source.
#
#   spawn_with_venv.sh split-window -h
#   spawn_with_venv.sh new-window


if (($# < 1)); then
    echo "usage: spawn_with_venv.sh <tmux-command> [args...]" >&2
    exit 1
fi


find_venv() {
    local dir=$1 name
    for name in ".venv" "venv"; do
        [[ -f "$dir/$name/pyvenv.cfg" ]] && { printf '%s\n' "$dir/$name"; return 0; }
    done
    return 1
}


cmd=$1; shift
pane_dir=$(tmux display-message -p -t "${TMUX_PANE}" "#{pane_current_path}")

args=(-c "$pane_dir")
if venv_dir=$(find_venv "$pane_dir"); then
    args+=(-e "ACTIVATE_VENV=$venv_dir/bin/activate")
fi

tmux "$cmd" "${args[@]}" "$@"

