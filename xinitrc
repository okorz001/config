#!/bin/sh

# ~/.xinitrc | ~/.xsession
# vim:ft=sh:

# slim will run .xsession with the window manager as the first argument.
# startx will not pass any arguments to .xinitrc so we spoof default.
if [ -n "$1" ]; then
    wm="$1"
else
    wm="default"
fi

case "$wm" in
    awesome|default)
        # Load Xresources.
        xrdb -merge ~/.Xresources

        # Load keymap.
        xmodmap ~/.xmodmaprc

        # Start xscreensaver without the about window.
        xscreensaver -nosplash &

        # Start urxvt daemon with a custom socket. This allows multiple
        # daemons to run simultaneously in the case of multiple X servers.
        # urxvtd is not robust enough to use one instance for all X servers.
        export RXVT_SOCKET="/tmp/urxvt-$(whoami)-$DISPLAY"
        urxvtd -o &

        # Start the alsa applet.
        volumeicon &

        # Start the Network Manager applet.
        nm-applet &

        # Start the thunar daemon.
        thunar --daemon &

        # Start the battery applet.
        xfce4-power-manager --no-daemon &

        # Start awesome.
        exec awesome
        ;;

    *)
        # Otherwise we trust that this is a valid window manager.
        exec "$wm"
        ;;
esac
