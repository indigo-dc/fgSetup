# OS
#FROM mysql:latest
FROM mysql:5

# Maintainer
MAINTAINER Riccardo Bruno <riccardo.bruno@ct.infn.it>

# Environment for FGDB
ENV FG_USER futuregateway
ENV FG_DIR /home/futuregateway
ENV MYSQL_ROOT_PASSWORD rpass
ENV FGDB_HOST fgdb 
ENV FGDB_PORT 3306
ENV FGDB_USER fgapiserver
ENV FGDB_PASSWD fgapiserver_password
ENV FGDB_NAME fgapiserver
ENV FGDB_GIT https://github.com/FutureGatewayFramework/fgAPIServer.git
ENV FGDB_BRANCH master
# Environment for scripts
ENV FGSETUP_GIT https://github.com/FutureGatewayFramework/fgSetup.git
ENV FGSETUP_BRANCH master
# Environment for GridEngine EI
ENV UTDB_HOST $FGDB_HOST 
ENV UTDB_PORT 3306
ENV UTDB_USER tracking_user
ENV UTDB_PASSWORD usertracking
ENV UTDB DATABASE userstracking
ENV GNCENG https://github.com/csgf/grid-and-cloud-engine.git
ENV GNCENG_BRANCH FutureGateway

# User and working directory
WORKDIR $FG_DIR

# Package Installation and TeSS cloning
RUN adduser --disabled-password --gecos "" $FG_USER &&\
    chown -R $FG_USER:$FG_USERS $FG_DIR &&\
    apt-get update &&\
    apt-get install -y --no-install-recommends ca-certificates\
    sudo git mlocate vim &&\
    sudo echo "$FG_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* 

# User and working directory
USER $FG_USER
WORKDIR $FG_DIR

# Getting FG repo
RUN git clone $FGDB_GIT -b $FGDB_BRANCH

# Configure FutureGateway Database creation script to use values
# specified in the environment variables:
#
# FGDB_NAME     Database name
# FGDB_USER     Database username  
# FGDB_PASSWD   Database user password
#
# FG database
RUN sed -i "s/drop\ database\ if\ exists\ fgapiserver;/drop\ database\ if\ exists\ $FGDB_NAME;/"  fgAPIServer/fgapiserver_db.sql &&\
    sed -i "s/create\ database\ fgapiserver;/create\ database\ $FGDB_NAME;/" fgAPIServer/fgapiserver_db.sql &&\
# FG user@%
    sed -i "s/create\ user\ 'fgapiserver'\@'%'/create\ user\ '$FGDB_USER'\@'%'/" fgAPIServer/fgapiserver_db.sql &&\
    sed -i "s/alter\ user\ 'fgapiserver'\@'%'\ identified\ by\ \"fgapiserver_password\";/alter\ user\ 'fgapiserver'\@'%'\ identified\ by\ \"$FGDB_PASSWD\";/" fgAPIServer/fgapiserver_db.sql &&\
    sed -i "s/on\ fgapiserver.\*/on\ $FGDB_NAME.\*/" fgAPIServer/fgapiserver_db.sql &&\
    sed -i "s/to\ 'fgapiserver'\@'%'/to\ '$FGDB_USER'\@'%'/" fgAPIServer/fgapiserver_db.sql &&\
# FG user@localhost
    sed -i "s/create\ user\ 'fgapiserver'\@'localhost'/create\ user\ '$FGDB_USER'\@'localhost'/" fgAPIServer/fgapiserver_db.sql &&\
    sed -i "s/alter\ user\ 'fgapiserver'\@'localhost'\ identified\ by\ \"fgapiserver_password\";/alter\ user\ 'fgapiserver'\@'localhost'\ identified\ by\ \"$FGDB_PASSWD\";/" fgAPIServer/fgapiserver_db.sql &&\
    sed -i "s/on\ fgapiserver.\*/on\ $FGDB_NAME.\*/" fgAPIServer/fgapiserver_db.sql &&\
    sed -i "s/to\ 'fgapiserver'\@'localhost'/to\ '$FGDB_USER'\@'localhost'/" fgAPIServer/fgapiserver_db.sql

# FutureGateway scripts
RUN git clone $FGSETUP_GIT -b $FGSETUP_BRANCH &&\
    mkdir -p .fgprofile &&\
    cp fgSetup/scripts/commons .fgprofile/commons &&\
    cp fgSetup/scripts/fgdb .fgprofile/fgdb &&\
    cp fgSetup/scripts/ei_gridengine .fgprofile/ei_gridengine &&\
# Configure scripts
    sed -i "s/^FGDB_HOST.*/export FGDB_HOST=$FGDB_HOST/" .fgprofile/fgdb &&\
    sed -i "s/^FGDB_PORT.*/export FGDB_PORT=$FGDB_PORT/" .fgprofile/fgdb &&\
    sed -i "s/^FGDB_USER.*/export FGDB_USER=$FGDB_USER/" .fgprofile/fgdb &&\
    sed -i "s/^FGDB_PASSWD.*/export FGDB_PASSWD=$FGDB_PASSWD/" .fgprofile/fgdb &&\
    sed -i "s/^FGDB_NAME.*/export FGDB_NAME=$FGDB_NAME/" .fgprofile/fgdb &&\
    sed -i "s/^ASDB_OPTS.*/export ASDB_OPTS=''/" .fgprofile/fgdb &&\
    sed -i "s/^FGDB_ROOTPWD.*/export FGDB_ROOTPWD=$MYSQL_ROOT_PASSWORD/" .fgprofile/fgdb 

#
# Additional setup for Executor Interfaces
#

# Grid and Cloud Engine UsersTracking database
RUN git clone $GNCENG -b $GNCENG_BRANCH &&\
    sed -i "s/^UTDB_HOST.*/export UTDB_HOST=$UTDB_HOST/" .fgprofile/ei_gridengine &&\
    sed -i "s/^UTDB_PORT.*/export UTDB_PORT=$UTDB_PORT/" .fgprofile/ei_gridengine &&\
#    sed -i "s/^UTDB_USER.*/export UTDB_USER=$UTDB_USER/" .fgprofile/ei_gridengine &&\
#    sed -i "s/^UTDB_PASSWD.*/export UTDB_PASSWD=$UTDB_PASSWD/" .fgprofile/ei_gridengine &&\
#    sed -i "s/^UTDB_NAME.*/export UTDB_NAME=$UTDB_NAME/" .fgprofile/ei_gridengine &&\
    sed -i "s/^UTDB_OPTS.*/export UTDB_OPTS=''/" .fgprofile/ei_gridengine

# Working directory
USER root
#RUN sed -i "s/#bind-address\t=\ 127.0.0.1/bind-address     =\ 127.0.0.1/" /etc/mysql/mysql.conf.d/mysqld.cnf
RUN cat $FG_DIR/fgAPIServer/fgapiserver_db.sql > /docker-entrypoint-initdb.d/dbsetup.sql &&\
    cat $FG_DIR/grid-and-cloud-engine/UsersTrackingDB/UsersTrackingDB.sql >> /docker-entrypoint-initdb.d/dbsetup.sql

# FGDB mySQL port available to the world outside this container
EXPOSE $FGDB_PORT 

# Setup FGDB profile (all users)
RUN echo "for f in \$(find $FG_DIR/.fgprofile -type f); do source \$f; done # FGLOADENV" >> /etc/profile.d/fgdb.sh &&\
    echo "127.0.0.1 $FGDB_HOST" >> /etc/hosts
