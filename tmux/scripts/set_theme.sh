#!/bin/bash
# Usage: ./set_theme.sh [theme]
#
# shellcheck disable=SC2034 # Suppress "unused variable" warning

user_name="$(whoami)"
time_format="%-H:%M:%S %Z"
date_format="%F %a"


# Icons
rarrow=""
larrow=""
user_icon=" "
session_icon=" "
time_icon=" "
date_icon=" "


# Colors
# WARN: Capital hex colors might fail due to variable expansion (see: tmux/issues/3239)
RED="#ae2a34"
ORANGE="#ff8f2d"
YELLOW="#d3bc00"
GREEN="#008a3c"
BLUE="#00659c"
PURPLE="#8a00c8"
WHITE="#aeaeae"

G01="#080808"
G02="#121212"
G03="#1c1c1c"
G04="#262626"
G05="#303030"
G06="#3a3a3a"
G07="#444444"
G08="#4e4e4e"
G09="#585858"
G10="#626262"
G11="#6c6c6c"
G12="#767676"


theme="${1:-white}"
case "$theme" in
    red)
        TC="$RED"               # Theme color
        HL="$GREEN"             # Highlight
        TD="$G01"               # Theme dark accent color
        TM="$G03"               # Theme medium accent color
        TL="$TC"                # Theme light accent color
        ;;
    orange)
        TC="$ORANGE"
        HL="$BLUE"
        TD="$G01"
        TM="$G04"
        TL="$TC"
        ;;
    yellow)
        TC="$YELLOW"
        HL="$PURPLE"
        TD="$G01"
        TM="$G05"
        TL="$TC"
        ;;
    green)
        TC="$GREEN"
        HL="$RED"
        TD="$G01"
        TM="$G03"
        TL="$TC"
        ;;
    blue)
        TC="$BLUE"
        HL="$ORANGE"
        TD="$G01"
        TM="$G03"
        TL="$TC"
        ;;
    purple)
        TC="$PURPLE"
        HL="$YELLOW"
        TD="$G01"
        TM="$G03"
        TL="$TC"
        ;;
    white)
        TC="$WHITE"
        HL="$G09"
        TD="$G01"
        TM="$G03"
        TL="$TC"
        ;;
    critical)
        TC="#ffff00"
        HL="#00ff00"
        TD="#ff0000"
        TM="#0000ff"
        TL="$TC"
        ;;
    *)
        # echo "Unknown theme: $theme"
        exit 0
        ;;
esac


# Status options
tmux set -gq status on
tmux set -gq status-interval 1
tmux set -gq status-position bottom
tmux set -gq status-style "fg=${TL},bg=${TD},none"


# Window status
tmux set -gq window-status-separator ""
tmux set -gq window-status-format         "#[fg=${TD},bg=${TM}]${rarrow}#[fg=${TL},bg=${TM}] #I:#W#F #[fg=${TM},bg=${TD}]${rarrow}"
tmux set -gq window-status-current-format "#[fg=${TD},bg=${TL}]${rarrow}#[fg=${TD},bg=${TL},bold] #I:#W#F #[fg=${TL},bg=${TD},nobold]${rarrow}"


# Left side of status bar
ls_user="#[fg=${TD},bg=${TL},bold]#{?client_prefix,#[bg=${HL}],} ${user_icon} ${user_name}@#h "
ls_sep1="#[fg=${TL},bg=${TM},nobold]#{?client_prefix,#[fg=${HL}],}${rarrow}"
ls_session="#[fg=${TL},bg=${TM}] ${session_icon} #S "
ls_sep2="#[fg=${TM},bg=${TD},nobold]${rarrow}"

LS="${ls_user}${ls_sep1}${ls_session}${ls_sep2}"
tmux set -gq status-left-length 150
tmux set -gq status-left "$LS"


# Right side of status bar
tmux set -gq @status_alt 0
tmux bind A if-shell -F "#{==:#{@status_alt},1}" \
    "set -gq @status_alt 0 ; set -gq @alt_str ''" \
    "run-shell 'tmux set -gq @alt_str \"\$(python3 ~/Dev/almanac/almanac.py)\" ; tmux set -gq @status_alt 1'"

rs_sep1="#[fg=${TM}]${larrow}"
rs_time="#[fg=${TL},bg=${TM}] ${time_icon} ${time_format} "
rs_sep2="#[fg=${TL},bg=${TM}]${larrow}"
rs_date="#[fg=${TD},bg=${TL}] #{?#{==:#{@status_alt},0},${date_icon} ${date_format},#{@alt_str}} "

RS="${rs_sep1}${rs_time}${rs_sep2}${rs_date}"
tmux set -gq status-right-length 150
tmux set -gq status-right "$RS"


# Panes
tmux set -gq pane-border-style        "fg=${TM},bg=default"
tmux set -gq pane-active-border-style "fg=${TC},bg=default"


# Other styles
tmux set -gq prompt-cursor-colour "$HL"
tmux set -gq message-style "fg=${HL},bg=${TD}"  # Messages
tmux set -gq mode-style    "fg=${TD},bg=${HL}"  # Copy mode (highlighting)


# Clock mode
tmux set -gq clock-mode-colour "$TC"
tmux set -gq clock-mode-style 12

