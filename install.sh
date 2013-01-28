#!/bin/bash
# Set up symbolic links for configuration files.

error () {
    echo "$(basename $0): error: $1" >&2
}

while getopts ":hb:fnq" opt; do
    case "$opt" in
        h)
            cat <<HERE
Usage: $(basename $0) [-hfnq] [-b SUFFIX]

Set up symbolic links for configuration files.

Options:
    -h              Show this help message and quit.
    -b SUFFIX       Backup existing files with the specified suffix.
    -f              Overwrite existing files.
    -n              Do not execute any commands (i.e. dry run).
    -q              Do not echo commands before executing.
HERE
            exit 0
            ;;
        b)
            suffix="$OPTARG"
            ;;
        f)
            force="f"
            ;;
        n)
            dry_run=1
            ;;
        q)
            quiet=1
            ;;
        \?)
            error "invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            error "missing argument for option: -$OPTARG"
            exit 1
            ;;
    esac
done

# If $XDG_CONFIG_HOME is not defined, fallback to $HOME/.config.
# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
xdg_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

# List of files to install. Every two elements are logically paired; the first
# is the repository relative path and the second is the absolute install path.
files=(
    "Xresources"    "$HOME/.Xresources"
    "awesome"       "$xdg_dir/awesome"
    "bashrc"        "$HOME/.bashrc"
    "bashrc.d"      "$HOME/.bashrc.d"
    "colordiffrc"   "$HOME/.colordiffrc"
    "conkyrc"       "$HOME/.conkyrc"
    "emacs.d/init.el"   "$HOME/.emacs.d/init.el"
    "gdbinit"       "$HOME/.gdbinit"
    "gitconfig"     "$HOME/.gitconfig"
    "hgrc"          "$HOME/.hgrc"
    "inputrc"       "$HOME/.inputrc"
    "profile"       "$HOME/.profile"
    "profile"       "$HOME/.xsessionrc"
    "profile.d"     "$HOME/.profile.d"
    "screenrc"      "$HOME/.screenrc"
    "urxvt/ext"     "$HOME/.urxvt/ext"
    "vimrc"         "$HOME/.vimrc"
    "xinitrc"       "$HOME/.xinitrc"
    "xinitrc"       "$HOME/.xsession"
    "xmodmaprc"     "$HOME/.xmodmaprc"
)

# Execute a command while respecting the -n and -q options.
# TODO: This breaks if shell control characters are used. (e.g. a pipe)
execute () {
    [[ -z "$quiet" ]] && echo "$@"
    [[ -z "$dry_run" ]] && $@
}

for (( i = 0; i < ${#files[@]}; i += 2 )); do
    src="$(pwd)/${files[i]}"
    dst="${files[i + 1]}"

    if [[ -f "$dst" && -n "$suffix" ]]; then
        execute cp "$dst" "$dst$suffix"
    fi

    execute ln -sn"$force" "$src" "$dst"
done
