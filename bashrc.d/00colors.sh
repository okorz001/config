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
