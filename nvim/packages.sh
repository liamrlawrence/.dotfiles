#!/bin/bash


packages=(
    ripgrep fd-find         # Telescope (Grep + file search)
)

sudo apt-get install "${packages[@]}"

