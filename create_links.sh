#!/bin/bash
# NOTE: Run from .dotfiles/


BACKUPDIR="$(pwd)/.old"
LOGFILE="$BACKUPDIR/links.log"
if [ -f "$LOGFILE" ]; then
    echo "Log file found: $LOGFILE"
    echo "Please use 'remove_links.sh' before trying to recreate links"
    exit 1
fi
mkdir -p "$BACKUPDIR"
echo "ran $0 $(date +'%F %R')" > "$LOGFILE"


create_symlink() {
    local link_path=$1
    link_dir="$(dirname $link_path)"
    link_file="$(basename $link_path)"
    target_path="$(pwd)/$(basename $link_path)"

    if [ -L "$link_path" ]; then
        echo "[$link_file] Symbolic link already exists: $link_path"
        return
    fi

    if [ -e "$link_path" ]; then
        backup_path="$BACKUPDIR/$link_file"
        mv "$link_path" "$backup_path"
        echo "moved $link_path $backup_path" >> "$LOGFILE"
        echo "[$link_file] Moved: $link_path -> $backup_path"
    fi

    if [ ! -d "$link_dir" ]; then
        mkdir -p "$link_dir"
        echo "mkdir $link_dir" >> "$LOGFILE"
        echo "[$link_file] Created directory: $link_dir"
    fi

    ln -s "$target_path" "$link_path"
    echo "symlink $link_path $target_path" >> "$LOGFILE"
    echo "[$link_file] Created symbolic link: $link_path -> $target_path"
}


# $HOME setup
home_files=(
    "$HOME/.bashrc"
)
for file in "${home_files[@]}"; do
    create_symlink "$file"
done


# ~/.config setup
config_directories=(
    "$HOME/.config/tmux"
    "$HOME/.config/nvim"
)
for dir in "${config_directories[@]}"; do
    create_symlink "$dir"
done

