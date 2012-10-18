# Turn on completion unless we are in strict POSIX mode.
if [[ -r /etc/bash_completion ]] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
