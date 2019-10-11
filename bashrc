# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
     . /etc/bashrc
fi

# enable programmable completion features.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# My function definitions.
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Causes bash to append to history instead of overwriting it so if you
# start a new terminal, you have old session history.
shopt -s histappend
PROMPT_COMMAND='history -a'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# double tap ctrl-d to close the terminal.
export IGNOREEOF=1

# Set the default editor.
if is_command vim; then
    export EDITOR="$(command -v vim) -f"
else
    export EDITOR="$(command -v vi) -f"
fi

# Set the sudo editor. Use gvim if we are not in an SSH term and the
# X11 display number is under 10.
if is_command gvim && [ "$SSH_TTY$DISPLAY" = "${DISPLAY#*:[1-9][0-9]}" ]; then
  export VISUAL="$(command -v gvim) -f"
  SUDO_EDITOR="$VISUAL"
else
  SUDO_EDITOR="$EDITOR"
fi

# make less more friendly for non-text input files, see lesspipe(1)
is_command lesspipe && eval "$(SHELL=/bin/sh lesspipe)"

# Fix terminal colour in xfce terminal.
if [ "$COLORTERM" == "xfce4-terminal" ]; then
    export TERM=xterm-256color
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Get the number of colours supported by the terminal.
term_colours=$(tput colors)

# Set bash prompt and colours.
if [ "$term_colours" = "256" ]; then
    export PS1="\[\033[38;5;204m\]\u\[$(tput sgr0)\]\[\033[38;5;102m\]@\[$(tput sgr0)\]\[\033[38;5;109m\]\h\[$(tput sgr0)\]\[\033[38;5;102m\]:\[$(tput sgr0)\]\[\033[38;5;72m\]\w\[$(tput sgr0)\]\[\033[38;5;102m\] \\$ \[$(tput sgr0)\]"
else
    export PS1="\[\033[38;5;1m\]\u\[$(tput sgr0)\]\[\033[38;5;7m\]@\[$(tput sgr0)\]\[\033[38;5;6m\]\h\[$(tput sgr0)\]\[\033[38;5;7m\]:\[$(tput sgr0)\]\[\033[38;5;2m\]\w\[$(tput sgr0)\]\[\033[38;5;7m\] \\$ \[$(tput sgr0)\]"
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases.
if is_command dircolors; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Color for manpages in less.
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Source additional bash config files.
if [ -d $HOME/.bashrc.d ]; then
    files=`find "$HOME/.bashrc.d/" -regextype sed -regex ".*/bash_.*[^~]$"`
    for i in $files; do
        source $i
    done
fi
