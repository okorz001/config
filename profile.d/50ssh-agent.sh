# Define the ssh-agent socket name so that we can find instances more easily.
SSH_AUTH_SOCK="/tmp/ssh-$USER"

if [ -S "$SSH_AUTH_SOCK" ]; then
    # Use the existing agent.
    export SSH_AUTH_SOCK
else
    # Create a new agent and use our special socket name.
    eval `ssh-agent -sa "$SSH_AUTH_SOCK"` >/dev/null
fi
