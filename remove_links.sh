#!/bin/bash
# NOTE: Run from .dotfiles/


BACKUPDIR="$(pwd)/.old"
LOGFILE="$BACKUPDIR/links.log"
if [ ! -f "$LOGFILE" ]; then
    echo "Log file not found: $LOGFILE"
    echo "Please use 'create_links.sh' to setup links"
    exit 1
fi
echo "ran $0 $(date +'%F %R')" >> "$LOGFILE"


remove_symlink() {
    local link_path=$1
    local use_sudo=$2
    link_file="$(basename $link_path)"
    if [ -L "$link_path" ]; then
        if [ "$use_sudo" -eq 1 ]; then
            echo "[$link_file] Removing Symbolic link: $link_path"
            sudo rm "$link_path"
        else
            echo "[$link_file] Removing symbolic link: $link_path"
            rm "$link_path"
        fi
        echo "removed $link_path" >> "$LOGFILE"
    else
        echo "[$link_file] No symbolic link found: $link_path"
    fi
}

restore_file() {
    local original_path=$1
    local backup_path=$2
    if [ -e "$backup_path" ] && [ ! -e "$original_path" ]; then
        mv "$backup_path" "$original_path"
        echo "moved $backup_path $original_path" >> "$LOGFILE"
        echo "[$(basename $original_path)] Restored: $backup_path -> $original_path"
    fi
}


tac "$LOGFILE" | while IFS= read -r line; do
    if [[ $line == [sS]ymlink* ]]; then
        symlink_path=$(echo $line | awk '{print $2}')
        used_sudo=$([[ ${line:0:1} == "S" ]] && echo 1 || echo 0 )
        remove_symlink "$symlink_path" "$used_sudo"
    elif [[ $line == moved* ]]; then
        original_path=$(echo $line | awk '{print $2}')
        backup_path=$(echo $line | awk '{print $3}')
        restore_file "$original_path" "$backup_path"
    fi
done


mv $LOGFILE "$BACKUPDIR/$(date +'%F_%R')_links.log"

