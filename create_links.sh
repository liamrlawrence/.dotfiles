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
    # Usage:
    #   create_symlink <link_path> [target_path] [use_sudo]
    #
    # Parameters:
    #   1) link_path   (required) The full path where the symlink should be created.
    #   2) target_path (optional) The file or directory the link should point to.
    #                    Defaults to "$(pwd)/$(basename "$link_path")" if omitted.
    #   3) use_sudo    (optional) If provided (any non-empty value), the link
    #                    command is run with sudo.
    local link_path=$1
    local target_path

    if [ -n "$2" ]; then
        target_path="$2"
    else
        target_path="$(pwd)/$(basename "$link_path")"
    fi

    link_dir="$(dirname $link_path)"
    link_file="$(basename $link_path)"

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

    if [ -n "$3" ]; then
        sudo ln -s "$target_path" "$link_path"
        echo "Symlink $link_path $target_path" >> "$LOGFILE"    # NOTE: Capital S for sudo-symlink
        echo "[$link_file] Created Symbolic link: $link_path -> $target_path"
    else
        ln -s "$target_path" "$link_path"
        echo "symlink $link_path $target_path" >> "$LOGFILE"
        echo "[$link_file] Created symbolic link: $link_path -> $target_path"
    fi
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


# Language setup
create_symlink "/etc/profile.d/go.sh" "$(pwd)/languages/go/go_profile.sh"           1
create_symlink "$HOME/.config/black"  "$(pwd)/languages/python/black_config.toml"

