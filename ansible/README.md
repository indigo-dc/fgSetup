# ANSIBLE installation
The FutureGateway framework can be also deployed using ansible.
Different roles are available for each specific FutureGateway compoenent; in particular:
* FutureGateway database
* APIServer front-end (fgAPIServer) *(not available yet)*
* APIServer (APIServerDaemon) *(not available yet)*
* Liferay62 *(not available yet)*
* Liferay7 *(not available yet)*
* LiferayIAM *(not available yet)*

## Usage
Before to install any node; verify that the account used to access the remote machine can connect via ssh as root without prompting for password. This is achieved properly configuring the ssh key file exchange.
To start the installation, configure first the `hosts` inventory file with the correct hostnames, then configure variable files under `vars/` directory and execute
```sh
ansible-playbook -i hosts <component name>
```
For instance to setup the database component just execute:
```sh
ansible-playbook -i hosts setupdb.yml
```


