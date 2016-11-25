# fgSetup
This software installs and upgrades FutureGateway components.
It provides a flexible solution to install different components on different hosts having each a different architecture.
The setup procedure can be executed more times in order to upgrade the existing system.

# Components
The setup procedure supports the following FutureGateway components:

* fgdb - The FutureGateway database
* fgAPIServer - The python version of APIServer (front-end)
* APIServerDaemon - The Java version of the APIServerDaemon (queue polling) and its related Executor Interfaces
* Liferay62 - A liferay portal and eventually its SDK
* Liferay7 - A liferay portal and eventually its SDK

# Architectures
The setup procedure supports the followin OS architecture actually differentiated only by the package manager applicaions:

* brew - MacOSx 10.x
* apt - Debian/Ubuntu(14.04)
* yum - CentOS(7)

# How it works
The installation process foresees the following steps:

1. Identify the necessary components to install and FutureGateway services topology. In case more hosts are involved in the setup procedure, please ensure to run the setup from a host able to connect ssh to each node passwordlessly properlyexchanging keys. Early phases of the setup try to identify any missing and mandatory configuration.
2. Modify the setup\_config.sh file configuring each FutureGateway service as designed above. For each component contains its own specific settings.
3. From the installation host, execute the script setup\_futuregateway.sh. The first time the setup procedure will install the component, while further execution will try to upgrade the components and its configurations accordingly to the values placed in the file setup\_config.sh





