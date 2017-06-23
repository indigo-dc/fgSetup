# Containers for the Container king

You like Ansible ! You like Containers ! You **LOVE** [Ansible Container](http://docs.ansible.com/ansible-container). You've tried the shell scripts. They were fun for a while, but you need something... a little... more... _exciting_. So you try yourself some Ansible. Now, we're getting somwhere, you think to yourself. Feels good to scratch that itch, doesn't it !? Yeah baby, right there...

But it's not enough for you. You need this done _right_, dammit. So, you think - what's next ? Then it comes to you :

**Just add containers !**

# How to use this stuff

You need AnsibleContainer. Go get it, I'll wait...

Now you can Orchestrate your Containers with Containers.

`ansible-container --var-file vars.yml build`

# Containers

The service orchestration is in `ansible/container.yml` This describes the services as well as the registries. Containers are pushed to [quay.io/aaroc](https://quay.io/aaroc)

  * [![Docker Repository on Quay](https://quay.io/repository/aaroc/ansiblecontainer-db/status "Docker Repository on Quay") db](https://quay.io/repository/aaroc/ansiblecontainer-db)
  * [![Docker Repository on Quay](https://quay.io/repository/aaroc/ansiblecontainer-apiserver/status "Docker Repository on Quay") api server](https://quay.io/repository/aaroc/ansiblecontainer-apiserver)
  * [![Docker Repository on Quay](https://quay.io/repository/aaroc/ansiblecontainer-apidaemon/status "Docker Repository on Quay") api daemon](https://quay.io/repository/aaroc/ansiblecontainer-apidaemon)
