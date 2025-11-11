#!/bin/bash


packages=(
    # Required for install_neovim.sh
    curl jq tar coreutils

    # Neovim
    ripgrep fd-find         # Telescope (Grep + file search)
)

sudo apt-get update && sudo apt-get install -y "${packages[@]}"

