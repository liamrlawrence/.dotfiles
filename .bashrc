# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples



# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


## HISTORY OPTIONS
HISTSIZE=10000          # 10k lines in memory
HISTFILESIZE=100000     # 100k lines on disk
HISTCONTROL=ignoreboth  # don't put duplicate lines or lines starting with space in the history
shopt -s histappend     # append to the history file, don't overwrite it

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


## PROMPT
if [[ $EUID -eq 0 ]]; then
    PS1='\[\033[01;31m\]\u@\h \[\033[01;33m\][ROOT]\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]$ '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# In Tmux, show (venv-name) in the prompt whenever VIRTUAL_ENV is set
# NOTE: New panes automatically source the first venv found
# HACK: If manually activating a venv just make a new pane instead, else prompt shows "(new-venv) (old-venv)"
if [[ -n "$TMUX" && -n "$VIRTUAL_ENV" ]]; then
    PS1="($(basename "$VIRTUAL_ENV")) $PS1"
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable color support for commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi



# Neovim
export NEOVIM_PATH="/usr/local/nvim-linux64/bin/nvim"
alias vim="$NEOVIM_PATH"
export SUDO_EDITOR="$NEOVIM_PATH"


# C
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Go
export PATH="$PATH:$GOROOT/bin"
export PATH="$PATH:$GOPATH/bin"


# Aliases
alias cleard='clear; date +%r'


# System
export MANPAGER="$NEOVIM_PATH +Man!"
export PATH="$PATH:$HOME/bin"

