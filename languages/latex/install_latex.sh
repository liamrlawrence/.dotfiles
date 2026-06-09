#!/bin/bash


if ! command -v cargo &>/dev/null; then
    echo "WARNING: cargo not found. Install Rust via rustup before running this script."
    echo "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
fi

packages=(
    latexmk
    build-essential clang libfontconfig1-dev poppler-utils unzip    # tdf dependencies
)
sudo apt-get update && sudo apt-get install -y "${packages[@]}"

cargo install --git https://github.com/itsjunetime/tdf.git          # terminal pdf viewer

