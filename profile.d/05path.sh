# This fragment constructs the PATH environment variable. Care must be taken to
# avoid clobbering elements added by the local system administrator.

# Debian does not put the sbin directories on the path.
# Not all of these programs actually require superuser (e.g. ifconfig).
for d in /sbin /usr/sbin /usr/local/sbin; do
    if ! echo $PATH | grep -q "$d"; then
        export PATH="$d:$PATH"
    fi
done

# Use ccache if we've got it.
if which ccache >/dev/null 2>/dev/null; then
    export PATH="/usr/lib/ccache:$PATH"
fi

# Add the home directory to the path. This is a convenient place to drop shell
# scripts. Give this highest priority so that we can alias real programs.
export PATH="$HOME/bin:$PATH"
