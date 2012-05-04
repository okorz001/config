# ~/.bashrc
# vim:ft=sh:

# Use vi key bindings.
set -o vi

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

# MSYSGIT: MSYS doesn't provide tput, but it does support ANSI colors.
if true; then
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
    # MSYSGIT: Only git is supported.
    echo "git"
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
