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
