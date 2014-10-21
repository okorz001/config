# ~/.profile | ~/.xsessionrc
# vim:ft=sh:

# Some display managers (e.g. lightdm) do not create a login shell when
# starting an X session. This is frustrating, because I depend on .profile
# being sourced in all situations. In order to maintain compatibility with
# display managers that DO create login shells (e.g. gdm), we need to create a
# cookie to track whether or not we have already sourced .profile.
[ -n "$PROFILE_SOURCED" ] && return
export PROFILE_SOURCED="`date`"

# Include modules in alphabetical order.
for f in ~/.profile.d/*.sh; do
    . $f
done

# Source local environment if it exists.
[ -e ~/.profile.local ] && . ~/.profile.local

# bash is stupid, so explicitly source bashrc for interactive login shells.
[ -n "$BASH" -a -n "$PS1" ] && . ~/.bashrc
