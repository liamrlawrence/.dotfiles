#!/bin/bash


packages=(
    # Required for install_neovim.sh
    wget jq

    # Neovim
    ripgrep fd-find         # Telescope (Grep + file search)
)

sudo apt-get install -y "${packages[@]}"

