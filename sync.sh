#!/bin/bash


directories=(
    "$HOME/.config/nvim"
    "$HOME/.config/tmux"
)



for dir in "${directories[@]}"; do
    rsync -av --delete ./"$(basename $dir)" "$(dirname $dir)"
done

