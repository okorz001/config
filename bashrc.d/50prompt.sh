# Set a cool prompt. __scm_ident is defined later.
PS1="$green\\u@\\h$white:$blue\\w$cyan\$(__scm_ident)\n$white\\\$$none "
PS2="$white>$none "

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
