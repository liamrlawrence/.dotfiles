#!/bin/bash


# Tmux
sudo apt-get install -y tmux

# Plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source-file ~/.config/tmux/tmux.conf

