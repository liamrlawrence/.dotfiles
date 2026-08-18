#!/bin/bash



session_file_name=".session.tmux"

# File delimiter: ASCII Unit Separator (US, 0x1F) — a non-printing byte that
# can't occur in a name, path, or command, so file fields never need escaping
# and their order doesn't matter for safety.
#
# We can't use US when reading tmux, though: `-F` escapes control bytes on
# output, so there we split on a plain '|' we insert into the format string.
# Each of the two tmux reads is arranged so exactly ONE field could itself
# contain a '|', and that field is placed LAST so `read` absorbs any embedded
# '|' into its final variable:
#   - window read: window_name is last (the other fields are numeric or a
#                  fixed-format layout string, so none can hold a '|')
#   - pane read:   pane path is last  (the other fields are numeric or the
#                  /dev/... tty, so none can hold a '|')
# The command is NOT read from tmux (capture_cmd derives it from ps), so it
# never rides through the '|' split — that is what keeps each read to a single
# arbitrary field. Everything is then re-emitted US-delimited.
DELIM=$'\037'


if [[ -z "$TMUX" ]]; then
    echo "Error: Must be run from inside a tmux session."
    exit 1
fi

# Reconstruct the foreground command running on a pane's tty. A shell pipeline
# ("tail -f x | cat") is several processes sharing one foreground process group,
# so we collect every foreground member (stat contains '+'), order them by PID
# (which matches left-to-right pipeline order), drop the shell and these scripts,
# and rejoin with ' | '. Joining on process boundaries — not on the '|' byte —
# means a lone process whose argument merely contains '|' stays a single segment.
#
# LIMITATION: this reads each process's resolved argv from ps, not the text typed.
# Aliases and shell expansions are already applied (`grep` may reappear as
# `grep --color=auto`), and redirections, builtins, and exact quoting are lost —
# they are shell state, not separate processes. Capturing the verbatim command
# line would require a shell-level hook (preexec / history), not ps.
#
# NOTE: separate '-o' flags, not '-o stat=,pid=,args='. The comma-combined form
# is misparsed by BSD/macOS ps (it reads everything after the first '=' as one
# column's header), yielding no pid/args. Separate flags work on Linux and macOS.
capture_cmd() {
    local tty_short=$1
    local out="" line
    while IFS= read -r line; do
        [[ -n "$line" ]] || continue
        [[ -n "$out" ]] && out+=" | "
        out+="$line"
    done < <(
        ps -t "$tty_short" -o stat= -o pid= -o args= 2>/dev/null |
            awk '$1 ~ /\+/ { pid=$2; $1=""; $2=""; sub(/^ +/,""); print pid"\t"$0 }' |
            sort -n |
            cut -f2- |
            grep -E -v '^(-bash|-zsh|-fish|bash|zsh|fish)$' |
            grep -E -v '(save_session\.sh|restore_session\.sh)'
    )
    printf '%s' "$out"
}


cwd="$(tmux display-message -p '#{pane_current_path}')"
session_file="$cwd/$session_file_name"
session_name="$(tmux display-message -p '#S')"

echo "Saving tmux session '$session_name' to $session_file..."
true > "$session_file" || { echo "Error: cannot write $session_file" >&2; exit 1; }


# 0. Session name, so restore can recreate it verbatim
printf 'session%s%s\n' "$DELIM" "$session_name" >> "$session_file"


# 1. Windows. Read from tmux with name LAST (the only window field that can
#    contain '|'), then re-emit US-delimited in natural order.
tmux list-windows -t "$session_name" \
    -F "#{window_index}|#{window_active}|#{window_layout}|#{window_name}" |
while IFS="|" read -r win_idx active layout name; do
    printf 'window%s%s%s%s%s%s%s%s\n' \
        "$DELIM" "$win_idx" "$DELIM" "$name" "$DELIM" "$layout" "$DELIM" "$active" >> "$session_file"
done


# 2. Panes. Read from tmux with path LAST (the only tmux-sourced pane field that
#    can contain '|'; the tty is always a /dev/... device path, so it never
#    holds a '|'). Derive the foreground command, then re-emit US-delimited
#    with the command last for readability.
tmux list-panes -s -t "$session_name" \
    -F "#{window_index}|#{pane_index}|#{pane_active}|#{pane_tty}|#{pane_current_path}" |
while IFS="|" read -r win_idx pane_idx active tty path; do
    full_cmd=$(capture_cmd "${tty#/dev/}")

    printf 'pane%s%s%s%s%s%s%s%s%s%s\n' \
        "$DELIM" "$win_idx" "$DELIM" "$pane_idx" "$DELIM" "$active" "$DELIM" "$path" "$DELIM" "$full_cmd" >> "$session_file"
done

echo "Done. State saved."
exit 0

