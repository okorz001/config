# ~/.bashrc
# vim:ft=sh:

# Abort if this isn't an interactive shell.
[[ -z "$PS1" ]] && return

# Turn on completion unless we are in strict POSIX mode.
if [[ -r /etc/bash_completion ]] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Get rid of that stupid command not found handler.
unset -f command_not_found_handle

# Use vi key bindings.
set -o vi

# Default to user-writeable only.
umask 022

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
    export GREP_OPTIONS="$GREP_OPTIONS --color=auto"
    export GREP_COLORS="sl=:cx=:mt=01;31:fn=01;36:ln=01;35:bn=01;35:se=01;37"

    # Colorize man pages (in less) like the linux console.
    # This is undocumented. A better solution would use termcap directly.
    export LESS_TERMCAP_us=$'\e[36m'
    export LESS_TERMCAP_ue=$'\e[0m'

    # Use colordiff if available
    if which colordiff &>/dev/null; then
        alias diff="colordiff"
    fi

    # Define some ANSI color codes. Note these are all bold/bright.
    black='\[\e[1;30m\]'
    red='\[\e[1;31m\]'
    green='\[\e[1;32m\]'
    yellow='\[\e[1;33m\]'
    blue='\[\e[1;34m\]'
    pink='\[\e[1;35m\]'
    cyan='\[\e[1;36m\]'
    white='\[\e[1;37m\]'
    none='\[\e[0m\]'
fi

# Set a cool prompt. __scm_ident is defined later.
PS1="$green\\u@\\h$white:$blue\\w$cyan\$(__scm_ident)\n$white\\\$$none "
PS2="$white>$none "

# Undefine temporary variables used for prompt construction.
unset -v black red green yellow blue pink cyan white none

case "$TERM" in
?term*|rxvt*)
    # If we're in a GUI terminal, set a nice window title.
    PS1='\[\e]0;\u@\h: \w\a\]'"$PS1"
    ;;
screen*)
    # If we're in screen, support automatic tab titles.
    # I really want to move this PS1, but that screws up checkwinsize.
    PROMPT_COMMAND="$PROMPT_COMMAND; echo -n \$'\ek\e\\\\'"
    ;;
esac

# Tell me where my files went.
alias cp="cp -v"
alias mv="mv -v"

# Sometimes I forget these aren't real commands.
alias ll="ls -lh"
alias la="ll -A"

# Convenient function for launching screen as a serial terminal.
# This will set a nice descriptive tab title as well.
screen-tty () {
    screen -t "$1" "$1" "${2:-115200}"
}

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

# Prints a SCM revision identifier.
# This is a convenience function that detects the SCM type, and then calls
# the appropriate SCM identification function.
__scm_ident () {
    # It's OK if the function is undefined because we're redirecting stderr.
    local i="$(__scm_"$(__scm_detect)"_ident 2>/dev/null)"
    if [[ -n "$i" ]]; then
        printf "${1:- (%s)}" "$i"
    fi
}

# Heuristic for determining the current SCM type.
__scm_detect () {
    # TODO: Cache the result? At least for the current directory?
    local d="$(pwd)"
    while true; do
        if [[ -d "$d/.git" ]]; then
            echo "git"
            return 0
        elif [[ -d "$d/.hg" ]]; then
            echo "hg"
            return 0
        elif [[ -d "$d/.svn" ]]; then
            echo "svn"
            return 0
        elif [[ -d "$d/CVS" ]]; then
            echo "cvs"
            return 0
        elif [[ "$d" == "/" ]]; then
            # If we're in the root dir and haven't found anything then give up.
            return 1
        fi

        # Try the parent directory.
        d="$(dirname "$d")"
    done

    # We shouldn't get here!
    return 1
}

# Based off the __git_ps1 function from the bash completion script for git.
__scm_git_ident () {
    # Find the git directory.
    local d=$(git rev-parse --git-dir 2>/dev/null) || return 1

    local b=""
    local m=""

    if [[ -d "$d/rebase-merge" ]]; then
        b="$(<"$d/rebase-merge/head-name")"

        if [[ -f "$d/rebase-merge/interactive" ]]; then
            m="|REBASE-i"
        else
            m="|REBASE-m"
        fi

    else
        # First, see if we are on a local branch.
        b="$(git symbolic-ref HEAD 2>/dev/null)"
        if [[ -n "$b" ]]; then
            b="${b##refs/heads/}"
        else
            # Next, see if we've checked out a tag.
            b="$(git describe --tags --exact-match HEAD 2>/dev/null)"
            if [[ -n "$b" ]]; then
                b="tag: $b"
            else
                # Finally, just use the abbreviated SHA1.
                b="$(<"$d/HEAD")"
                b="${b:0:7}..."
            fi
        fi

        if [[ -f "$d/rebase-apply/rebasing" ]]; then
            m="|REBASE"
        elif [[ -f "$d/rebase-apply/applying" ]]; then
            m="|AM"
        elif [[ -d "$d/rebase-apply" ]]; then
            m="|REBASE/AM?"
        elif [[ -f "$d/MERGE_HEAD" ]]; then
            m="|MERGE"
        elif [[ -f "$d/CHERRY_PICK_HEAD" ]]; then
            m="|CHERRY-PICK"
        elif [[ -f "$d/BISECT_HEAD" ]]; then
            m="|BISECT"
        fi
    fi

    echo "$b$m"
}

# TODO: This invokes hg, and thus python, four times.
# The best solution may be to parse the .hg directory ourselves.
__scm_hg_ident () {
    local b=""
    # First, see if we're using a bookmark.
    # We must seperate the assignment from the local builtin, because local
    # will return zero even if hg identify fails.
    b="$(hg identify -B 2>/dev/null)"
    # Mercurial is dumb and prints usage to stdout, so we have to check the
    # return code in case bookmarks aren't supported in this version.
    if [[ $? -ne 0 || -z "$b" ]]; then
        # Next, check if we've checked out a tag.
        b="$(hg identify -t 2>/dev/null)"
        if [[ -n "$b" ]]; then
            b="tag: $b"
        else
            # Finally, just use the local revision and the abbreviated SHA1.
            b="$(hg identify -n 2>/dev/null): $(hg identify -i 2>/dev/null)..."
        fi
    fi

    echo "$b"
}

__scm_svn_ident () {
    local r="$(svnversion 2>/dev/null)"
    r="${r/[^0-9]*/}"
    if [[ -n "$r" ]]; then
        echo "r$r"
    fi
}
