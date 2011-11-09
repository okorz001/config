# ~/.bashrc
# vim:ft=sh:

# Abort if this isn't an interactive shell.
[[ -z "$PS1" ]] && return

# Default to user-writeable only.
umask 022

# Use vi key bindings.
set -o vi

# Get rid of that stupid command not found handler.
unset -f command_not_found_handle

# Check if the window size has been adjusted.
shopt -s checkwinsize

# The history file lets command history persist between shells.
HISTFILE="$HOME/.bash_history"

# The number of commands to remember.
HISTSIZE="1024"

# The maximum number of lines in the history file.
HISTFILESIZE="2048"

# Append to the history file instead of overwriting.
shopt -s histappend

# Ignore commands that are immediately repeated or start with a space.
# Note that if a command is repeated out-of-order it will not be ignored.
HISTCONTROL="ignorespace:ignoredups"

# Colon delimited command ignore list using glob syntax.
# Common argument-less commands are not very interesting.
HISTIGNORE="exit:clear:ls:ll:la"

# Save and update history after every command.
PROMPT_COMMAND="history -a; history -r"

# Detect if this terminal type supports ANSI colors.
if [[ -x /usr/bin/tput ]] && tput setaf 1 &>/dev/null; then
    # Colorize ls. GNU and BSD userland disagree on how to do this.
    case "$(uname)" in
    Linux|CYGWIN*)
        alias ls="ls --color=auto"
        export LS_COLORS="no=00:di=01;34:ln=01;36:so=01;35:pi=01;35:ex=01;32:bd=01;33;40:cd=01;33;40:su=01;37;41:sg=01;37;43:tw=01;37;42:ow=01;37;42"
        ;;
    Darwin)
        export CLICOLOR="1"
        export LSCOLORS="ExGxFxFxCxDxDxHBHDHCHC"
        ;;
    esac

    # Colorize the grep family.
    export GREP_OPTIONS="--color=auto"

    # Define some ANSI color codes.
    green='\[\e[01;32m\]'
    blue='\[\e[01;34m\]'
    none='\[\e[00m\]'
fi

# Set a (potentially) colorful prompt.
PS1="${green}\u@\h${none}:${blue}\w${none}\n\\\$ "

# Undefine ANSI color codes.
unset green
unset blue
unset none

case "$TERM" in
?term*|rxvt*)
    # If we're in a GUI terminal, set a nice window title.
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
screen*)
    # If we're in screen, support automatic tab titles.
    # I really want to move this PS1, but that screws up checkwinsize.
    PROMPT_COMMAND="$PROMPT_COMMAND; echo -ne '\033k\033\\'"
    ;;
esac

# Turn on completion unless we are in strict POSIX mode.
if [[ -r /etc/bash_completion ]] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Tell me where my files went.
alias cp="cp -v"
alias mv="mv -v"

# Sometimes I forget these aren't real commands.
alias ll="ls -lh"
alias la="ll -A"

# Do math with python.
calc () {
    python -c "from math import *; print $@"
}

# Here's a wrapper for which that handles aliases, builtins and functions.
# This could screw up commands relying on which's output if $1 is not a file.
which () {
    local arg=""
    local err="0"

    for arg in $@; do
        case "$(type -t "$arg")" in
        alias)
            alias "$arg"
            ;;
        function)
            declare -f "$arg"
            ;;
        builtin)
            echo "$arg is a builtin"
            ;;
        *)
            /usr/bin/which "$arg" || err="1"
        esac
    done

    return "$err"
}
