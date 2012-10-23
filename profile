# ~/.profile
# vim:ft=sh:

# Include modules in alphabetical order.
for f in ~/.profile.d/*.sh; do
    . $f
done

# bash is stupid, so explicitly source bashrc for interactive login shells.
[ -n "$BASH" -a -n "$PS1" ] && . ~/.bashrc
