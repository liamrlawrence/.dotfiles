#!/bin/bash



session_file_name=".session.tmux"

# Field delimiter for the state file: ASCII Unit Separator (US, 0x1F).
# See the comment in save_session.sh for more details.
DELIM=$'\037'


if [[ -z "$TMUX" ]]; then
    echo "Error: Must be run from inside a tmux session."
    exit 1
fi

cwd="$(tmux display-message -p '#{pane_current_path}')"
session_file="$cwd/$session_file_name"

if [[ ! -f "$session_file" ]]; then
    echo "Error: $session_file_name not found in $cwd."
    exit 1
fi


# Read entire file into memory first
session_lines=()
while IFS= read -r line; do
    [[ -n "$line" ]] && session_lines+=("$line")
done < "$session_file"


# Determine the session name: prefer the one saved in the file, fall back to the
# directory name (tmux forbids '.' and ':' in names, so translate them).
session_name=""
for line in "${session_lines[@]}"; do
    IFS="$DELIM" read -r type name <<< "$line"
    if [[ "$type" == "session" ]]; then
        session_name="$name"
        break
    fi
done
[[ -z "$session_name" ]] && session_name=$(basename "$cwd" | tr '.:' '--')

if tmux has-session -t "=$session_name" 2>/dev/null; then
    echo "Error: Session '$session_name' already exists. Ignoring."
    exit 1
fi

echo "Restoring tmux session '$session_name'..."


# Start detached session, sized to the current window (client_width/tput are
# unavailable under run-shell; window_width resolves correctly there).
cols=$(tmux display-message -p '#{window_width}'  2>/dev/null); cols=${cols:-120}
lines=$(tmux display-message -p '#{window_height}' 2>/dev/null); lines=${lines:-40}
tmux new-session -d -s "$session_name" -n "restore_dummy" -x "$cols" -y "$lines"
dummy_win_id=$(tmux display-message -p -t "$session_name" -F "#{window_id}")

tmux move-window -s "$dummy_win_id" -t "$session_name:999"

window_layouts=()
window_names=()
active_win=""


# Pass 1: Parse window metadata from memory
for line in "${session_lines[@]}"; do
    IFS="$DELIM" read -r type win_idx name layout active <<< "$line"
    [[ "$type" == "window" ]] || continue

    window_names[win_idx]=$name
    window_layouts[win_idx]=$layout
    [[ "$active" == "1" ]] && active_win="$win_idx"
done

win_initialized=()
active_panes=()


# Pass 2: Provision panes and run commands from memory
for line in "${session_lines[@]}"; do
    IFS="$DELIM" read -r type win_idx _ active path full_cmd <<< "$line"
    [[ "$type" == "pane" ]] || continue

    if [[ -z "${win_initialized[win_idx]}" ]]; then
        win_initialized[win_idx]=1
        tmux new-window -d -t "$session_name:$win_idx" -n "${window_names[win_idx]}" -c "$path"
        pane_id=$(tmux list-panes -t "$session_name:$win_idx" -F "#{pane_id}" | head -n 1)
    else
        tmux select-layout -t "$session_name:$win_idx" tiled
        # NOTE: Don't use -d here. This ensures the newly created pane becomes active,
        # meaning the next split builds off this one instead of pane 0, preserving index order.
        pane_id=$(tmux split-window -t "$session_name:$win_idx" -c "$path" -P -F "#{pane_id}")
    fi

    if [[ "$active" == "1" ]]; then
        active_panes[win_idx]="$pane_id"
    fi

    if [[ -n "$full_cmd" ]]; then
        tmux send-keys -t "$pane_id" "$full_cmd" C-m
    fi
done


# Apply layouts
for win_idx in "${!window_layouts[@]}"; do
    tmux select-layout -t "$session_name:$win_idx" "${window_layouts[win_idx]}"

    if [[ -n "${active_panes[win_idx]}" ]]; then
        tmux select-pane -t "${active_panes[win_idx]}"
    fi
done

tmux kill-window -t "$dummy_win_id" 2>/dev/null || true

if [[ -n "$active_win" ]]; then
    tmux select-window -t "$session_name:$active_win"
fi

echo "Session '$session_name' restored successfully."
tmux switch-client -t "$session_name"
exit 0

