#!/bin/bash


directories=(
    "$HOME/.config/nvim"
    "$HOME/.config/tmux"
)


for dir in "${directories[@]}"; do
    base_name="$(basename "$dir")"
    target_dir="$(dirname "$dir")"

    local_path="$(pwd)/$base_name"
    link_path="$target_dir/$base_name"

    if [ ! -L "$link_path" ]; then
        ln -s "$local_path" "$link_path"
        echo "Created symbolic link: $local_path -> $link_path"
    else
        echo "Symbolic link already exists: $link_path"
    fi
done

