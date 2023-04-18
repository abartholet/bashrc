#!/usr/bin/env bash

# Check if a given command exists.
is_command() {
    if command -v $1 > /dev/null 2>&1; then
        true
    else
        false
    fi
}

# Append a path to the PATH variable if it's not already in it.
path_append() {
    for ARG in "$@"
    do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="${PATH:+"$PATH:"}$ARG"
        fi
    done
}

# Prepend a path to the PATH variable if it's not already in it.
path_prepend() {
    for ((i=$#; i>0; i--)); 
    do
        ARG=${!i}
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="$ARG${PATH:+":$PATH"}"
        fi
    done
}

# Basic logging function to print the name of the calling script
logger() {
    echo "[$(basename $0)] ${1}"
}

# Trim leading and trailing white space.
trim() {
    local var="$*"
    # remove leading white space characters.
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing white space characters.
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

# Replace a give file or directory with a symlink
# backup the original.
create_symlink() {
    if [ ! -h $2 ]; then
        backup $2
        rm -rf $2
        ln -s $1 $2
    fi
}

# Create a backup with a timestamped name.
backup()
{
    if [ -f $1 ]; then
        backup_suffix=`date +%Y%m%d-%H%M%S-%N~`
        cp -r ${1}{,.${backup_suffix}}
    fi
}

md()
{
  tmpfile=$(mktemp)
  tmpfile=$tmpfile.html
  pandoc $1 > $tmpfile
  xdg-open $tmpfile
}

