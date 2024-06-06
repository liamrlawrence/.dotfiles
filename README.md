# .dotfiles

## Setup
1. Create symlinks & backup old configs
  - Run `create_links.sh`

2. Tmux
  - `tmux/scripts/install_tmux.sh`
  - Start a tmux session and press `<prefix>I` to install plugins

3. Neovim
  - `nvim/scripts/install_packages.sh`
  - `nvim/scripts/install_neovim.sh`
  - Start a vim session to install plugins

## Teardown
1. Remove symlinks & restore old files / directories
  - Run `remove_links.sh`

