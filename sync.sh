#!/bin/bash


directories=()
while read -r line; do
    if [ ! -z "$line" ]; then
        directories+=("$(eval echo "$line")")
    fi
done < "directories.txt"


for dir in "${directories[@]}"; do
    rsync -av --delete ./"$(basename $dir)" "$(dirname $dir)"
done

