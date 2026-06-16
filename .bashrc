# ~/.bashrc


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


## History Options
HISTSIZE=10000          # 10k lines in memory
HISTFILESIZE=100000     # 100k lines on disk
HISTCONTROL=ignoreboth  # don't put duplicate lines or lines starting with space in the history
shopt -s histappend     # append to the history file, don't overwrite it

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


## Prompt
if [[ $EUID -eq 0 ]]; then
    PS1='\[\033[01;31m\]\u@\h \[\033[01;33m\][ROOT]\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]$ '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi


## Title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"  # If this is an xterm set the title to user@host:dir
    ;;
*)
    ;;
esac


## Terminal
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi


## Neovim
export NEOVIM_PATH="/usr/local/nvim-linux/bin/nvim"


## C
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


## Go
[[ -d "$GOPATH" ]] && export PATH="$GOPATH/bin:$PATH"


## Rust
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"


## Python
[[ -n "$ACTIVATE_VENV" ]] && { source "$ACTIVATE_VENV"; unset ACTIVATE_VENV; }  # activate venvs in tmux panes with split_window.sh


## Color commands
bind 'set colored-completion-prefix on'
bind 'set colored-stats on'
alias ls='ls --color=auto'
alias grep='grep --color=auto'


## Aliases
alias cleard='clear; date +%r'
alias ll='ls -alFh'
alias la='ls -A'


## System
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"
export PATH="${NEOVIM_PATH%/*}:$PATH"

export VISUAL="$NEOVIM_PATH"
export EDITOR="$NEOVIM_PATH"
export GIT_EDITOR="$NEOVIM_PATH"
export SUDO_EDITOR="$NEOVIM_PATH"
export MANPAGER="$NEOVIM_PATH +Man!"

