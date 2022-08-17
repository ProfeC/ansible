# Automation ideas for Ansible.

Linux hosts will be configured for Fedora (Redhat) first. Debian based systems will follow.

## Localhost DEV Environment

- Podman (instead of Docker)
  - Remove Docker if it's there first?
  - What about Windows & MocOS targets?
- VS Code & server
  - Can we get out plugins too?
- Git
  - Git terminal (?)
  - Smartgit
  - Main repos in the "projects" directory
    - DEV branch checked out by default
  - Commit template
- Python (?)
- NPM / Yarn
  - NPM is the standard, but Yarn "looks" better
- MySQL/db server?
  - As a container?
  - Can we config it with defaults too?
  - Any other DB server?
- DBeaver DB Manager
- WSL2 (Windows)
- Filezilla?
- fish & oh-my-fish (Linux, MacOS, & WSL2?)
- Firefox
- Chrome/Vivaldi/Brave
- cURL
- wget
- nano
- vim

### Other localhost apps

- VLC
- Timeshift (btrfs only)
- Shortwave (Linux only)
- Spotify (?)
- Discord

## Containers for Media Management

- PLEX/Jellyfin
- Sonarr
- Radarr
- Readarr or equivalent
- Jackett
- Transmission or QBittorrent
- VPN

## Maintenance for Servers

- Server updates
- Service updates

## Directory Structure

This layout organizes most tasks in roles, with a single inventory file for each environment and a few playbooks in the top-level directory: __(REF: Ansible Docs - Sample Layout)__

```console
production                # inventory file for production servers
staging                   # inventory file for staging environment

group_vars/
   group1.yml             # here we assign variables to particular groups
   group2.yml
host_vars/
   hostname1.yml          # here we assign variables to particular systems
   hostname2.yml

library/                  # if any custom modules, put them here (optional)
module_utils/             # if any custom module_utils to support modules, put them here (optional)
filter_plugins/           # if any custom filter plugins, put them here (optional)

site.yml                  # main playbook
webservers.yml            # playbook for webserver tier
dbservers.yml             # playbook for dbserver tier
tasks/                    # task files included from playbooks
    webservers-extra.yml  # &lt;-- avoids confusing playbook with task files
```

### Roles

```yml
roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  &lt;-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  &lt;-- handlers file
        templates/        #  &lt;-- files for use with the template resource
            ntp.conf.j2   #  &lt;------- templates end in .j2
        files/            #
            bar.txt       #  &lt;-- files for use with the copy resource
            foo.sh        #  &lt;-- script files for use with the script resource
        vars/             #
            main.yml      #  &lt;-- variables associated with this role
        defaults/         #
            main.yml      #  &lt;-- default lower priority variables for this role
        meta/             #
            main.yml      #  &lt;-- role dependencies
        library/          # roles can also include custom modules
        module_utils/     # roles can also include custom module_utils
        lookup_plugins/   # or other types of plugins, like lookup in this case

    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/               # ""
</pre>
```

## Command Examples

Run the playbook on a specific set of hosts

```shell
ansible-playbook -i staging ./playbooks/setup-fedora-workstation.yaml -vv -C -e "user=$(whoami)" -K
```

## References

- [Lee's (aka ProfeC) dot files](https://github.com/ProfeC/dotfiles)
- [How to automatically set up a development machine with Ansible](https://stribny.name/blog/ansible-dev/)
- [Automate your coding environment with Ansible and make a simple GUI for it using only #!bash Scripting](https://dev.to/meseta/automate-your-coding-environment-with-ansible-and-make-a-simple-gui-for-it-using-only-bash-scripting-3742)
- [Ansible Docs - Sample Setup Guide](https://docs.ansible.com/ansible/latest/user_guide/sample_setup.html)
