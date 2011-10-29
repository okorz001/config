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

# Use vim for text editing. Fallback to vi if we're on some sad POS.
if which vim >/dev/null 2>/dev/null; then
	export EDITOR="vim"
else
	export EDITOR="vi"
fi

# Use less for paging.
export PAGER="less"

# Set default flags for less.
export LESS="-FSRXx4"

# Use the path to find a less preprocessor.
# Unfortunately, there isn't a standard name for these.
if which lesspipe >/dev/null 2>/dev/null; then
    export LESSOPEN="|`which lesspipe` %s"
elif which lesspipe.sh >/dev/null 2>/dev/null; then
    export LESSOPEN="|`which lesspipe.sh` %s"
fi

# bash is stupid, so explicitly source bashrc for interactive login shells.
[ -n "$BASH" -a -n "$PS1" ] && . ~/.bashrc
