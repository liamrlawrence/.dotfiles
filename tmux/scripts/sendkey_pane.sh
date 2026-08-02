#!/bin/bash


set -euo pipefail

if [ -z "${TMUX-}" ]; then
    echo "This script must be run inside a tmux session." >&2
    exit 1
fi

usage() {
    cat >&2 <<'EOF'
Usage:
    sendkey_pane.sh --x {left|right} --y {top|bottom} [-k] command [args...]

Examples:
    sendkey_pane.sh --x left  --y top    htop
    sendkey_pane.sh --x right --y bottom tail -f /var/log/syslog
    sendkey_pane.sh --x right --y bottom -k tail -f /var/log/syslog
EOF
}


x_dir=""
y_dir=""
kill_first=0

while [ $# -gt 0 ]; do
    case "${1:-}" in
        -h|--help) usage; exit 0 ;;
        --x|-x) shift; x_dir="${1:-}" ;;
        --y|-y) shift; y_dir="${1:-}" ;;
        -k) kill_first=1 ;;
        --) shift; break ;;
        *) break ;;
    esac
    shift
done

x_dir=$(echo "$x_dir" | tr '[:upper:]' '[:lower:]')
y_dir=$(echo "$y_dir" | tr '[:upper:]' '[:lower:]')

if [[ -z "$x_dir" || -z "$y_dir" ]]; then
    echo "Error: you must provide both --x and --y." >&2
    usage
    exit 1
fi
if [[ "$x_dir" != "left" && "$x_dir" != "right" ]]; then
    echo "Error: --x must be 'left' or 'right'." >&2
    exit 1
fi
if [[ "$y_dir" != "top" && "$y_dir" != "bottom" ]]; then
    echo "Error: --y must be 'top' or 'bottom'." >&2
    exit 1
fi
if [ $# -eq 0 ] && [[ "$kill_first" != "1" ]]; then
    echo "Error: you must provide a command to run." >&2
    usage
    exit 1
fi

cmd=( "$@" )
window_id="$(tmux display-message -p '#{window_id}')"
active_pane_id="$(tmux display-message -p '#{pane_id}')"

pane_count="$(tmux list-panes -t "$window_id" | wc -l | tr -d ' ')"
if [[ "$pane_count" == "1" ]]; then
    bash ~/.config/tmux/scripts/split_window.sh -h -d -t "$active_pane_id" -c "#{pane_current_path}"
fi


target_pane="$(
    tmux display-message -p -t "$window_id" '#{window_layout}' \
    | grep -Eo '[0-9]+x[0-9]+,[0-9]+,[0-9]+,[0-9]+' \
    | awk -F'[x,]' -v x="$x_dir" -v y="$y_dir" '
        {
            w=$1; h=$2; px=$3; py=$4; id=$5;
            xm = (x=="left") ? px : -(px + w - 1);
            ym = (y=="top")  ? py : -(py + h - 1);
            print "%" id, xm, ym;
        }
    ' \
    | sort -k2,2n -k3,3n \
    | awk 'NR==1 {print $1}'
)"

if [[ "$kill_first" == "1" ]]; then
    tmux send-keys -t "$target_pane" C-c
fi

if [ ${#cmd[@]} -gt 0 ]; then
    tmux send-keys -t "$target_pane" "${cmd[*]}" C-m
fi

