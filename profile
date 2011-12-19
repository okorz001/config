# ~/.profile
# vim:ft=sh:

# Some distributions (cough, CentOS) alias which in /etc/profile.
case `type -t which` in
alias)
    unalias which
    ;;
function)
    unset -f which
    ;;
esac

# Check my home directory for programs.
export PATH="$HOME/bin:$PATH"

# Use ccache if we've got it.
if which ccache >/dev/null 2>/dev/null; then
    export PATH="/usr/lib/ccache:$PATH"
fi

# Set the locale. Other LC_xxx variables can be infered from this.
export LANG="en_US.UTF-8"

# Use simple ASCII sorting. This puts '.' before [0-9] then [A-Z] then [a-z].
# This could screw up things depending on en_US.UTF-8 sort (where A = a).
export LC_COLLATE="C"

# Use vim for text editing. Fallback to vi if we're on some sad POS.
if which vim >/dev/null 2>/dev/null; then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi

# Use less for paging.
export PAGER="less"

# Set default flags for less.
#    -F : quit if one screen
#    -S : disable line wrapping
#    -R : print ANSI color escape sequences
#    -X : disable termcap init (don't clear screen on close)
#    -x : tab stop width
export LESS="-FSRXx4"

# Use the path to find a less preprocessor.
# Unfortunately, there isn't a standard name for these.
if which lesspipe >/dev/null 2>/dev/null; then
    export LESSOPEN="|`which lesspipe` %s"
elif which lesspipe.sh >/dev/null 2>/dev/null; then
    export LESSOPEN="|`which lesspipe.sh` %s"
fi

# Set default flags for grep.
#    -I : ignore binary files
#    --exclude-dir='\.*' : do not recurse into hidden directories
export GREP_OPTIONS="-I --exclude-dir='\\.*'"

# bash is stupid, so explicitly source bashrc for interactive login shells.
[ -n "$BASH" -a -n "$PS1" ] && . ~/.bashrc
