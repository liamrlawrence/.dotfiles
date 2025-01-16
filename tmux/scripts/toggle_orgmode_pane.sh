#!/bin/bash
# When the keybind is pressed:
#   - If it does not exist, create a new pane and start an orgmode vim session
#   - If the orgmode pane exists and is not focused, jump to it
#   - If the orgmode pane exists and is focused, swap focus back to the previous pane


show_help() {
cat << EOF
Usage: $0 [OPTIONS]

Options:
  --fullscreen      Open the panes in fullscreen mode
  --help            Display this help message and exit
EOF
}

# Flags
fullscreen=false

# Parse commandline arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --fullscreen) fullscreen=true ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done


if [ -z "$TMUX" ]; then
    echo "Error: Not in a tmux session"
    exit 1
fi



notes_dir="$HOME/Notes/drawer"
file_ending="notes.org"
current_pane_dir="$(tmux display-message -p '#{pane_current_path}')"
file_name="$(echo $current_pane_dir | sed -e 's|^/||' -e 's|/|_|g')_${file_ending}"
file_path="${notes_dir}/${file_name}"
run_cmd="vim $file_path"


# Check each pane's PID to see if already open
pane_ids="$(tmux list-panes -F '#{pane_pid} #{pane_id}')"
target_pane_id=""

for pid in $(echo "$pane_ids" | awk '{print $1}'); do
    cmd=$(ps -p "$pid" -o args=)
    if [[ "$cmd" == *"$run_cmd"* ]]; then
        target_pane_id=$(echo "$pane_ids" | grep "$pid" | awk '{print $2}')
        break
    fi
done


# Open or toggle focus of the orgmode pane
if [ -z "$target_pane_id" ]; then
    if [ ! -f "$file_path" ]; then
        mkdir -p "$(dirname $file_path)"
        echo "#+TITLE: Notes drawer for ${current_pane_dir}" >> "$file_path"
        echo "#+AUTHOR: Liam Lawrence" >> "$file_path"
    fi

    tmux split-window -p 35 -h -c "$current_pane_dir" "bash -i -c '$run_cmd'"
else
    current_pane_id=$(tmux display-message -p '#{pane_id}')
    if [ "$current_pane_id" == "$target_pane_id" ]; then
        tmux last-pane
    else
        tmux select-pane -t "$target_pane_id"
    fi
fi

if [ "$fullscreen" == true ]; then
    tmux resize-pane -Z
fi

