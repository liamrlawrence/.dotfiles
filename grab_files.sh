#!/bin/bash


directories=(
    "$HOME/.config/nvim"
    "$HOME/.config/tmux"
)



for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        rsync -av --delete "$dir"/ ./"$(basename $dir)"
    else
        echo "Directory $dir does not exist."
    fi
done

