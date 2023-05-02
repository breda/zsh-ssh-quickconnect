#
# SSH quickconnect
#
# Just a simple utility function that grabs all hosts from .ssh/config file & known_hosts (when a Host entry uses glob matching)
# and prints them for selection using fzf and SSHes into the selected entry.
#

function sshqc() {
    local ssh_config="$HOME/.ssh/config"
    local ssh_known_hosts="$HOME/.ssh/known_hosts"
    local disregard="github.com|gitlab.com|bitbucket.org"
    

    # Get Host entries from config
    local hosts=($(grep -E "^Host " $ssh_config | cut -f 2 -d " " | grep -v "^*$" | grep -v -E $disregard))
    local remotes=()

    for host in $hosts
    do
        # Grab the user from SSH config
        local user=$(ssh -G $host | grep -E '^user ' | cut -f 2 -d " ")

        # In this case, we have a glob in the Host name
        # We get all matching hostnames by looking them up in the known_hosts file
        if [[ $host =~ "\*" ]]; then
            known_hosts=($(grep -E "^$host" $ssh_known_hosts 2>/dev/null | cut -f 1 -d " " | uniq))

            for known_host in $known_hosts
            do
                remotes=(${remotes[@]} "$user@$known_host")
            done
        else
            # Append the entry to remotes
            remotes=(${remotes[@]} "$user@$host")
        fi
    done

    selected=$(printf "%s\n" "${remotes[@]}" | fzf)

    # If nothing was selected
    if [[ -z $selected ]]; then
        echo "Nothing to do"
    else
        echo "SSHing into $selected now... \n"
        eval "ssh $selected"
    fi
}
