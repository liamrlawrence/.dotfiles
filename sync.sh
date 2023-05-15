#!/bin/bash


directories=(
    "$HOME/.config/nvim"
    "$HOME/.config/tmux"
)



for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "Directory $dir does not exist. Creating it now..."
        mkdir -p "$dir"
    fi

    rsync -av --delete ./"$(basename $dir)" "$dir"/ 
done

