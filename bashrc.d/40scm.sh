# Prints a SCM revision identifier.
# This is a convenience function that detects the SCM type, and then calls
# the appropriate SCM identification function.
__scm_ident () {
    # It's OK if the function is undefined because we're redirecting stderr.
    local i="$(__scm_"$(__scm_detect)"_ident 2>/dev/null)"
    if [[ -n "$i" ]]; then
        printf "${1:- (%s)}" "$i"
    fi
}

# Heuristic for determining the current SCM type.
__scm_detect () {
    # TODO: Cache the result? At least for the current directory?
    local d="$(pwd)"
    while true; do
        if [[ -d "$d/.git" ]]; then
            echo "git"
            return 0
        elif [[ -d "$d/.hg" ]]; then
            echo "hg"
            return 0
        elif [[ -d "$d/.svn" ]]; then
            echo "svn"
            return 0
        elif [[ -d "$d/CVS" ]]; then
            echo "cvs"
            return 0
        elif [[ "$d" == "/" ]]; then
            # If we're in the root dir and haven't found anything then give up.
            return 1
        fi

        # Try the parent directory.
        d="$(dirname "$d")"
    done

    # We shouldn't get here!
    return 1
}

# Based off the __git_ps1 function from the bash completion script for git.
__scm_git_ident () {
    # Find the git directory.
    local d=$(git rev-parse --git-dir 2>/dev/null) || return 1

    local b=""
    local m=""

    if [[ -d "$d/rebase-merge" ]]; then
        b="$(<"$d/rebase-merge/head-name")"

        if [[ -f "$d/rebase-merge/interactive" ]]; then
            m="|REBASE-i"
        else
            m="|REBASE-m"
        fi

    else
        # First, see if we are on a local branch.
        b="$(git symbolic-ref HEAD 2>/dev/null)"
        if [[ -n "$b" ]]; then
            b="${b##refs/heads/}"
        else
            # Next, see if we've checked out a tag.
            b="$(git describe --tags --exact-match HEAD 2>/dev/null)"
            if [[ -n "$b" ]]; then
                b="tag: $b"
            else
                # Finally, just use the abbreviated SHA1.
                b="$(<"$d/HEAD")"
                b="${b:0:7}..."
            fi
        fi

        if [[ -f "$d/rebase-apply/rebasing" ]]; then
            m="|REBASE"
        elif [[ -f "$d/rebase-apply/applying" ]]; then
            m="|AM"
        elif [[ -d "$d/rebase-apply" ]]; then
            m="|REBASE/AM?"
        elif [[ -f "$d/MERGE_HEAD" ]]; then
            m="|MERGE"
        elif [[ -f "$d/CHERRY_PICK_HEAD" ]]; then
            m="|CHERRY-PICK"
        elif [[ -f "$d/BISECT_HEAD" ]]; then
            m="|BISECT"
        fi
    fi

    echo "$b$m"
}

# TODO: This invokes hg, and thus python, four times.
# The best solution may be to parse the .hg directory ourselves.
__scm_hg_ident () {
    local b=""
    # First, see if we're using a bookmark.
    # We must seperate the assignment from the local builtin, because local
    # will return zero even if hg identify fails.
    b="$(hg identify -B 2>/dev/null)"
    # Mercurial is dumb and prints usage to stdout, so we have to check the
    # return code in case bookmarks aren't supported in this version.
    if [[ $? -ne 0 || -z "$b" ]]; then
        # Next, check if we've checked out a tag.
        b="$(hg identify -t 2>/dev/null)"
        if [[ -n "$b" ]]; then
            b="tag: $b"
        else
            # Finally, just use the local revision and the abbreviated SHA1.
            b="$(hg identify -n 2>/dev/null): $(hg identify -i 2>/dev/null)..."
        fi
    fi

    echo "$b"
}

__scm_svn_ident () {
    local r="$(svnversion 2>/dev/null)"
    r="${r/[^0-9]*/}"
    if [[ -n "$r" ]]; then
        echo "r$r"
    fi
}
