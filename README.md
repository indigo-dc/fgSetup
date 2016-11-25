# fgSetup
FutureGateway setup and  upgrading system

This software installs and upgrades FutureGateway components.
It provides a flexible solution to install different components on different hosts having each a different architecture.

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



