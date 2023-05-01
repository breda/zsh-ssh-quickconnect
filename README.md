# zsh-ssh-quickconnect

Just a simple utility function that grabs all hosts from .ssh/config file & known_hosts (when a Host entry uses glob matching)
and prints them for selection using fzf and SSHes into the selected entry.

Just clone this repo somewhere then source the `.sh` script in your .zshrc somewhere

```bash
git clone https://github.com/breda/zsh-ssh-quickconnect $ZSH/plugins/ssh-quick-connect
```


```bash
source $ZSH/plugins/zsh-ssh-quickconnect.plugin.sh
```

Then run `sshqc` anytime to start SSHing

```bash
sshqc
```

## Why this might be useful for you
I'm usually managing a couple boxes that I need to SSH into, the way I manage them is I have DNS entries that looks like "bastion.staging.work"
 or something like that, and then in my SSH config file I have something like

```
Host *.staging.work
    IdentityFile /home/user/.ssh/work/staging

Host *.production.work
    IdentityFile /home/user/.ssh/work/prod
```

But because I name the DNS entries differently I can't be bothered to remember them all, so this utility function grabs all defined `Host`s from my SSH config,
expands any entries containing globs with I have on my known_hosts file and displays a nice list to choose from. Making it easier and faster to SSH into a target box.
