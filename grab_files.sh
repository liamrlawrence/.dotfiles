#!/bin/bash


directories=()
while read -r line; do
    if [ ! -z "$line" ]; then
        directories+=("$(eval echo "$line")")
    fi
done < "directories.txt"


for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        rsync -av --delete "$dir"/ ./"$(basename $dir)"
    else
        echo "Directory $dir does not exist."
    fi
done

