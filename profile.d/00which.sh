# CentOS aliases which in an /etc/profile.d script.
case `type -t which` in
alias)
    unalias which
    ;;
function)
    unset -f which
    ;;
esac
