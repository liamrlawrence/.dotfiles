#!/bin/bash
# When the keybind is pressed:
#   - If it does not exist, create a new pane and start an orgmode vim session
#   - If the orgmode pane exists and is focused, save and quit the buffer (which causes the pane to close as well)
#   - If the orgmode pane exists and is not focused, jump to it


file_name=".notes.org"
run_cmd="vim $file_name"
pane_ids=$(tmux list-panes -F '#{pane_pid} #{pane_id}')
target_pane_id=""


# Check each pane's PID to see if already open
if [ ! -z "$pane_ids" ]; then
    for pid in $(echo "$pane_ids" | awk '{print $1}'); do
        cmd=$(ps -p "$pid" -o args=)
        if [[ "$cmd" == *"$run_cmd"* ]]; then
            target_pane_id=$(echo "$pane_ids" | grep $pid | awk '{print $2}')
            break
        fi
    done
fi


# Open, focus, or kill the orgmode pane
if [ -z "$target_pane_id" ]; then
    current_pane_dir=$(tmux display-message -p '#{pane_current_path}')
    tmux split-window -p 35 -h -c "$current_pane_dir" "bash -i -c '$run_cmd'"
else
    current_pane_id=$(tmux display-message -p '#{pane_id}')
    if [ "$current_pane_id" == "$target_pane_id" ]; then
        tmux send-keys -t "$current_pane_id" C-c
        tmux send-keys -t "$current_pane_id" :x! Enter
    else
        tmux select-pane -t "$target_pane_id"
    fi
fi

