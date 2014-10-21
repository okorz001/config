# ~/.bashrc
# vim:ft=sh:

# Abort if this isn't an interactive shell.
[[ -z "$PS1" ]] && return

# Include modules in alphabetical order.
for f in ~/.bashrc.d/*.sh; do
    . "$f"
done

# Source local config if it exists.
[ -e ~/.bashrc.local ] && . ~/.bashrc.local
