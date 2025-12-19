#!/bin/bash


set -euo pipefail

if [ -z "${TMUX-}" ]; then
    echo "This script must be run inside a tmux session." >&2
    exit 1
fi

usage() {
    cat >&2 <<'EOF'
Usage:
  sendkey_pane.sh --x {left|right} --y {top|bottom} command [args...]

Examples:
  sendkey_pane.sh --x left  --y top    htop
  sendkey_pane.sh --x right --y bottom tail -f /var/log/syslog
EOF
}


x_dir=""
y_dir=""

while [ $# -gt 0 ]; do
    case "${1:-}" in
        -h|--help) usage; exit 0 ;;
        --x|-x) shift; x_dir="${1:-}" ;;
        --y|-y) shift; y_dir="${1:-}" ;;
        --) shift; break ;;
        *) break ;;
    esac
    shift
done

x_dir="${x_dir,,}"  # to lower
y_dir="${y_dir,,}"  # to lower

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
if [ $# -eq 0 ]; then
    echo "Error: you must provide a command to run." >&2
    usage
    exit 1
fi

cmd=( "$@" )

target_pane="$(
  tmux list-panes -F '#{pane_id} #{pane_left} #{pane_right} #{pane_top} #{pane_bottom}' \
  | awk -v x="$x_dir" -v y="$y_dir" '
      {
        id=$1; l=$2; r=$3; t=$4; b=$5;
        xm = (x=="left") ? l : -r;
        ym = (y=="top")  ? t : -b;
        print id, xm, ym;
      }
    ' \
  | sort -k2,2n -k3,3n \
  | awk 'NR==1 {print $1}'
)"

tmux send-keys -t "$target_pane" "${cmd[@]}" C-m

