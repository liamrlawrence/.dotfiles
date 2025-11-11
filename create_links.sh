#!/bin/bash
# NOTE: Run from .dotfiles/

set -euo pipefail

BACKUPDIR="$(pwd)/.old"
LOGFILE="$BACKUPDIR/links.log"

usage() {
    cat <<'EOF'
Usage:
    ./create_links.sh                   # setup everything
    ./create_links.sh [flags...]        # setup only selected components

Flags:
    --tmux
    --nvim
    --bashrc
    --lang-go
    --lang-python
    -h, --help
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

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
    #   2) target_path (optional) The file/dir the link should point to.
    #                    Defaults to "$(pwd)/$(basename "$link_path")" if omitted.
    #   3) use_sudo    (optional) If provided (any non-empty value), use sudo.
    local link_path=$1
    local target_path

    if [ -n "${2:-}" ]; then
        target_path="$2"
    else
        target_path="$(pwd)/$(basename "$link_path")"
    fi

    local link_dir
    link_dir="$(dirname "$link_path")"
    local link_file
    link_file="$(basename "$link_path")"

    if [ -L "$link_path" ]; then
        echo "[$link_file] Symbolic link already exists: $link_path"
        return
    fi

    if [ -e "$link_path" ]; then
        local backup_path="$BACKUPDIR/$link_file"
        mv "$link_path" "$backup_path"
        echo "moved $link_path $backup_path" >> "$LOGFILE"
        echo "[$link_file] Moved: $link_path -> $backup_path"
    fi

    if [ ! -d "$link_dir" ]; then
        mkdir -p "$link_dir"
        echo "mkdir $link_dir" >> "$LOGFILE"
        echo "[$link_file] Created directory: $link_dir"
    fi

    if [ -n "${3:-}" ]; then
        sudo ln -s "$target_path" "$link_path"
        echo "Symlink $link_path $target_path" >> "$LOGFILE"    # NOTE: Capital S for sudo-symlink
        echo "[$link_file] Created Symbolic link: $link_path -> $target_path"
    else
        ln -s "$target_path" "$link_path"
        echo "symlink $link_path $target_path" >> "$LOGFILE"
        echo "[$link_file] Created symbolic link: $link_path -> $target_path"
    fi
}

# Individual setup actions
setup_tmux() {
    create_symlink "$HOME/.config/tmux"
}

setup_nvim() {
    create_symlink "$HOME/.config/nvim"
}

setup_bashrc() {
    create_symlink "$HOME/.bashrc"
}

setup_lang_go() {
    create_symlink "/etc/profile.d/go.sh" "$(pwd)/languages/go/go_profile.sh" 1
}

setup_lang_python() {
    create_symlink "$HOME/.config/black" "$(pwd)/languages/python/black_config.toml"
}


# Parse flags
DO_TMUX=false
DO_NVIM=false
DO_BASHRC=false
DO_LANG_GO=false
DO_LANG_PY=false

if [ $# -eq 0 ]; then
    # No args: do everything
    DO_TMUX=true
    DO_NVIM=true
    DO_BASHRC=true
    DO_LANG_GO=true
    DO_LANG_PY=true
else
    while [ $# -gt 0 ]; do
        case "$1" in
            --tmux)         DO_TMUX=true ;;
            --nvim)         DO_NVIM=true ;;
            --bashrc)       DO_BASHRC=true ;;
            --lang-go)      DO_LANG_GO=true ;;
            --lang-python)  DO_LANG_PY=true ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Unknown flag: $1"
                usage
                exit 2
                ;;
        esac
        shift
    done
fi


# Execute selected actions
$DO_TMUX        && setup_tmux
$DO_NVIM        && setup_nvim
$DO_BASHRC      && setup_bashrc
$DO_LANG_GO     && setup_lang_go
$DO_LANG_PY     && setup_lang_python

