# Use vim for basic editing. Fallback to vi if necessary.
if which vim >/dev/null 2>/dev/null; then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi
