# Load all ssh keys into the ssh-agent. This heuristically detects private keys
# by finding public keys and removing the .pub suffix.
function load_ssh_keys () {
    local i
    for i in ~/.ssh/*.pub; do
        ssh-add "${i%.pub}"
    done
}
