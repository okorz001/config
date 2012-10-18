# Here's a wrapper for which that handles aliases, builtins and functions.
# This could screw up commands relying on which's output if $1 is not a file.
which () {
    local arg=""
    local err="0"

    for arg in $@; do
        case "$(type -t "$arg")" in
        alias)
            alias "$arg"
            ;;
        function)
            declare -f "$arg"
            ;;
        builtin)
            echo "$arg is a builtin"
            ;;
        *)
            /usr/bin/which "$arg" || err="1"
        esac
    done

    return "$err"
}
