# ANSIBLE installation
The FutureGateway framework can be also deployed using ansible.
Different roles are available for each specific FutureGateway compoenent; in particular:
* FutureGateway database
* APIServer front-end (fgAPIServer)
* APIServer (APIServerDaemon)
* Liferay62 *(not available yet)*
* Liferay7 *(not available yet)*
* [LiferayIAM](https://galaxy.ansible.com/indigo-dc/ansible-role-liferay-iam/) role is availble on ansible galaxy

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

### Notes

* Ansible executes as sudo, please be sure root' SSH public key belongs to the installer user authorized key.

* Do not use the user 'futuregateway' to call ansible.

* On Ubuntu 14.04 default ansible is 1.5.x; in order to obtain latest ansible, please use the following instructions:

```sh
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update -y
sudo apt-get install -y ansible
```

## Galaxy roles
The installation procedure relies on several ansible galaxy roles; you can install them by executing:
```sh
# All components
sudo ansible-galaxy install geerlingguy.git

# Database
sudo ansible-galaxy install geerlingguy.mysql

# fgAPIServer
sudo ansible-galaxy install geerlingguy.apache
sudo ansible-galaxy install bobbyrenwick.pip

# LiferayIAM
ansible-galaxy install indigo-dc.ansible-role-liferay-iam
```
