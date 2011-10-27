# ~/.bashrc
# vim:ft=sh:

# Abort if this isn't a login shell.
[ -z "$PS1" ] && return

# Get rid of that stupid command not found handler.
unset -f command_not_found_handle

# Check my home directory for programs and libraries.
export PATH="$HOME/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/lib:$LD_LIBRARY_PATH"

# Check if the window size has been adjusted.
shopt -s checkwinsize

# The history file lets command history persist between shells.
HISTFILE=~/.bash_history

# The number of commands to remember.
HISTSIZE=1024

# The maximum number of lines in the history file.
HISTFILESIZE=2048

# Only remember unique commands.
HISTCONTROL=erasedups

# Append to the history file instead of overwriting.
shopt -s histappend

# Set default flags for less.
export LESS="-FSRXx4"

# Use lesspipe. See lesspipe(1) for more info.
[ -x /usr/bin/lesspipe ] && eval `lesspipe`

# Detect if this terminal type supports ANSI colors.
if [ -x /usr/bin/tput ] && tput setaf 1 &>/dev/null; then
    # Enable ls color support. See dircolors(1) for more info.
    [ -x /usr/bin/dircolors ] && eval `dircolors -b`

    # Make UNIX beautiful.
    alias ls="ls --color=auto"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # Define some ANSI color codes.
    green='\[\e[01;32m\]'
    blue='\[\e[01;34m\]'
    none='\[\e[00m\]'
fi

# Set a (potentially) colorful prompt.
PS1="${green}\u@\h${none}:${blue}\w${none}\$ "

# Undefine ANSI color codes.
unset green
unset blue
unset none

case "$TERM" in
xterm*|rxvt*)
    # If we're in a GUI terminal, set a nice window title.
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
screen*)
    # If we're in screen, support automatic tab titles.
    PROMPT_COMMAND='echo -ne "\033k\033\\"'
    ;;
*)
    ;;
esac

# Turn on completion unless we are in strict POSIX mode.
if [ -r /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Use ccache if we've got it.
if which ccache &>/dev/null; then
    export PATH="/usr/lib/ccache:$PATH"
fi

# Use vim for text editing. Fallback to vi if we're on some sad POS.
if which vim &>/dev/null; then
	export EDITOR=vim
else
	export EDITOR=vi
fi

# Use less for paging.
export PAGER=less

# Tell me where my files went.
alias cp='cp -v'
alias mv='mv -v'

# Sometimes I forget these aren't real commands.
alias ll='ls -lh'
alias la='ll -A'

# Here's a wrapper for which that handles aliases, builtins and functions.
# This could screw up commands relying on which's output if $1 is not a file.
# Unlike which, this only handles one argument.
which () {
	case `type -t "$1"` in
	alias)
		alias "$1"
		;;
	function)
		declare -f "$1"
		;;
	builtin)
		echo "$1 is a builtin"
		;;
	*)
		/usr/bin/which "$1"
	esac
}
