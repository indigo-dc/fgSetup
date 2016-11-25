#!/bin/bash
#
# FutureGateway configuration settings
#
# This script keeps the whole FutureGateway configuration
#
# Author: Riccardo Bruno <riccardo.bruno@ct.infn.it>
#

# Generic setup configurations

# Setup log file
FGLOG=/tmp/FutureGateway_setup.log            # If empty std-out only reporting for setup

# FutureGateway relies totallyon Git repository for its intallation
# Each adopter may use its own forked sources, so that GIT repository must be configured
# properly before to execute the setup
GIT_HOST=https://github.com                   # Git repository host
GIT_RAWHOST=https://raw.githubusercontent.com # Host address for raw content
GIT_REPO=FutureGateway                        # FutureGateway repositoty name
GIT_BASE=$GIT_HOST/$GIT_REPO                  # GitHub base repository endpoint
GIT_BASERAW=$GIT_RAWHOST/$GIT_REPO            # GitHub base for raw content

# Components setup configurations

# APIServerDB
#
# FutureGateway database is the core component of the Science Gateway framework
# It holds any configuration and user activity
# This component requires the following variables
FGDB_VARS="FGDB_HOST\
           FGDB_HOSTUNAME\
           FGDB_PORT\
           FGDB_NAME\
           FGDB_ROOTPWD\
           FGDB_USER\
           FGDB_PASSWD\
           FGDB_SSHPORT\
           FGDB_GITREPO\
           FGDB_GITTAG"
FGDB_HOST=localhost                  # Database server address
FGDB_HOSTUNAME=futuregateway         # Database host username
FGDB_PORT=3306                       # Database port number
FGDB_NAME=fgapiserver                # Database name
FGDB_ROOTPWD=                        # Leave it empty for no password
FGDB_USER=fgapiserver                # Database username
FGDB_PASSWD=fgapiserver_password     # Database username password
FGDB_SSHPORT=22                      # Database ssh port number
FGDB_GITREPO=fgAPIServer             # Database Git repository name
FGDB_GITTAG="minor_changes"                 # Database Git repository tag/branch name


# API front-end
#
# FutureGateway may have different kind of API front-ends.
# The principal aim of front-ends is to listen and accept incoming rest calls
# in accordance with FutureGateway APIs defined at http://docs.fgapis.apiary.io/#
# The first developed front-end is the fgAPIServer a python+Flask based implementation
#

# fgAPIServer
# This component requires the following variables
FGAPISERVER_VARS="FGAPISERVER_SETUP\
                  FGAPISERVER_HOST\
                  FGAPISERVER_HOSTUNAME\
                  FGAPISERVER_PORT\
                  FGAPISERVER_SSHPORT\
                  FGAPISERVER_WSGI\
                  FGAPISERVER_GITREPO\
                  FGAPISERVER_GITTAG"
FGAPISERVER_SETUP=1                  # Enable this flag to setup fgAPIServer
FGAPISERVER_HOST=localhost           # fgAPIServer server host address
FGAPISERVER_HOSTUNAME=futuregateway  # fgAPIServer host username 
FGAPISERVER_PORT=8888                # fgAPIServer port number (no WSGI)
FGAPISERVER_SSHPORT=22               # fgAPIServer ssh port number
FGAPISERVER_WSGI=1                   # 0 turn off WSGI configuration (apache)
FGAPISERVER_GITREPO=fgAPIServer      # fgAPIServer Git repository name
FGAPISERVER_GITTAG="master"          # fgAPIServer Git repository tag/branch name


# APIServer
#
# FutureGateway may have different API Server daemons
# Daemons extract tasks from the APIServer queue and execute tasks on DCIs
# calling the right executor interface as specified in the queue task record
# The first implemented APIServer is the APIServerDaemon a java application
# making use of JSAGA together with the CSGF Grid and Cloud Engine
#

# APIServerDaemon
# This component requires the following variables
APISERVERDAEMON_ENVS="APISERVERDAEMON_SETUP\
                      APISERVERDAEMON_HOST\
                      APISERVERDAEMON_HOSTUNAME\
                      APISERVERDAEMON_PORT\
                      APISERVERDAEMON_SSHPORT\
                      APISERVERDAEMON_GITREPO\
                      APISERVERDAEMON_GITTAG"
APISERVERDAEMON_SETUP=1                 # Enable this flag to setup APIServerDaemon
APISERVERDAEMON_HOST=localhost          # APIServerDaemon host address
APISERVERDAEMON_HOSTUNAME=futuregateway # APIServerDaemon host username
APISERVERDAEMON_PORT=8080               # APIServerDaemon port number
APISERVERDAEMON_SSHPORT=22              # APIServerDaemon SSH port number
APISERVERDAEMON_GITREPO=APIServerDaemon # fgAPIServer Git repository name
APISERVERDAEMON_GITTAG="master"         # fgAPIServer Git repository tag/branch name

# GridnCloud Engine DB settings
UTDB_FGAPPID=10000                   # FutureGateway appId in GridnCloud Engine
UTDB_HOST=localhost                  # Database server address
UTDB_HOSTUNAME=futuregateway         # Database host username
UTDB_PORT=3306                       # Database port number
UTDB_NAME=userstracking              # Database name
UTDB_ROOTPWD=                        # Leave it empty for no password
UTDB_USER=tracking_user              # Database username
UTDB_PASSWD=usertracking             # Database username password


# FGPortal
#
# The FutureGateway can operate with any already existing web portal technology thanks
# to the adoption of the REST APIs. For all those cases were adopting user communities
# do not have any portal, the FutureGateway can provide one of its own supported 
# web portal technologies
# The first supported technology was Liferay6.2 a platform supported by the CSGF
# The second supported technoogy is Liferay7 the platform supported during the 
# indigo-datacloud project
#

# Liferay62
# This component requires the following variables
FGPORTAL_LIFERAY62_ENVS="FGPORTAL_LIFERAY62\
                         FGPORTAL_LIFERAY62_HOST\
                         FGPORTAL_LIFERAY62_HOSTUNAME\
                         FGPORTAL_LIFERAY62_PORT\
                         FGPORTAL_LIFERAY62_SSHPORT\
                         FGPORTAL_LIFERAY62_DBHOST\
                         FGPORTAL_LIFERAY62_DBPORT\
                         FGPORTAL_LIFERAY62_DBNAME\
                         FGPORTAL_LIFERAY62_DBUSER\
                         FGPORTAL_LIFERAY62_DBPASS\
                         FGPORTAL_LIFERAY62_DBNAME\
                         FGPORTAL_LIFERAY62_SDK\
                         FGPORTAL_LIFERAY62_GITREPO\
                         FGPORTAL_LIFERAY62_GITTAG"
FGPORTAL_LIFERAY62_SETUP=0                # Enable this flag to support Liferay62 setup
FGPORTAL_LIFERAY62_HOST=localhost         # Liferay62 portal host address
FGPORTAL_LIFERAY62_HOSTUNAME=liferayadmin # Liferay62 portal host username
FGPORTAL_LIFERAY62_PORT=8080              # Liferay62 portal port number
FGPORTAL_LIFERAY62_SSHPORT=22             # Liferay62 portal ssh port
FGPORTAL_LIFERAY62_DBHOST=$FGDB_HOST      # Liferay62 portal database host 
FGPORTAL_LIFERAY62_DBPORT=$FGDB_PORT      # Liferay62 portal database port 
FGPORTAL_LIFERAY62_DBNAME=lportal         # Liferay62 portal database name
FGPORTAL_LIFERAY62_DBUSER=lportal         # Liferay62 portal database user
FGPORTAL_LIFERAY62_DBPASS=lportal         # Liferay62 portal database password
FGPORTAL_LIFERAY62_DBNAME=lportal         # Liferay62 portal database name
FGPORTAL_LIFERAY62_SDK=0                  # 0 turn off Liferay62 SDK installation
FGPORTAL_LIFERAY62_GITREPO=PortalSetup    # Liferay62 Git repository name
FGPORTAL_LIFERAY62_GITTAG=master          # Liferay62 Git repository tag/branch name

# Liferay7
# This component requires the following variables
FGPORTAL_LIFERAY7_ENVS="FGPORTAL_LIFERAY7
                        FGPORTAL_LIFERAY7_HOST=localhost\
                        FGPORTAL_LIFERAY7_HOSTUNAME\
                        FGPORTAL_LIFERAY7_PORT=8080\
                        FGPORTAL_LIFERAY7_SSHPORT\
                        FGPORTAL_LIFERAY7_DBHOST\
                        FGPORTAL_LIFERAY7_DBPORT\
                        FGPORTAL_LIFERAY7_DBNAME\
                        FGPORTAL_LIFERAY7_DBUSER\
                        FGPORTAL_LIFERAY7_DBPASS\
                        FGPORTAL_LIFERAY7_DBNAME\
                        FGPORTAL_LIFERAY7_SDK\
                        FGPORTAL_LIFERAY62_GITREPO\
                        FGPORTAL_LIFERAY62_GITTAG"
FGPORTAL_LIFERAY7_SETUP=1                # Enable this flag to support Liferay7 setup
FGPORTAL_LIFERAY7_HOST=localhost         # Liferay7 portal host address
FGPORTAL_LIFERAY7_HOSTUNAME=liferayadmin # Liferay7 portal host username
FGPORTAL_LIFERAY7_PORT=8080              # Liferay7 portal port number
FGPORTAL_LIFERAY7_SSHPORT=22             # Liferay7 portal ssh port
FGPORTAL_LIFERAY7_DBHOST=$FGDB_HOST      # Liferay7 portal database host 
FGPORTAL_LIFERAY7_DBPORT=$FGDB_PORT      # Liferay7 portal database port 
FGPORTAL_LIFERAY7_DBNAME=lportal         # Liferay7 portal database name
FGPORTAL_LIFERAY7_DBUSER=lportal         # Liferay7 portal database user
FGPORTAL_LIFERAY7_DBPASS=lportal         # Liferay7 portal database password
FGPORTAL_LIFERAY7_DBNAME=lportal         # Liferay7 portal database name
FGPORTAL_LIFERAY7_SDK=0                  # 0 turn off Liferay7 SDK installation
FGPORTAL_LIFERAY62_GITREPO=PortalSetup   # Liferay7 Git repository name
FGPORTAL_LIFERAY62_GITTAG=master         # Liferay7 Git repository tag/branch name



