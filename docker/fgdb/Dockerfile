# OS
#FROM mysql:latest
FROM mysql:5

# Maintainer
MAINTAINER Riccardo Bruno <riccardo.bruno@ct.infn.it>

# Environment
ENV FG_USER futuregateway
ENV FG_DIR /home/futuregateway
ENV MYSQL_ROOT_PASSWORD rpass
ENV FGDB_HOST localhost
ENV FGDB_PORT 3306
ENV FGDB_USER fgapiserver
ENV FGDB_PASSWD fgapiserver_password
ENV FGDB_NAME fgapiserver
ENV FGDB_GIT https://github.com/FutureGatewayFramework/fgAPIServer.git
ENV FGDB_BRANCH master 
ENV FGSETUP_GIT https://github.com/FutureGatewayFramework/fgSetup.git
ENV FGSETUP_BRANCH master

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

#
# Additional setup for Executor Interfaces
#

# Grid and Cloud Engine UsersTracking database
ENV UTDB_HOST fgdb
ENV UTDB_PORT 3306
ENV UTDB_USER tracking_user
ENV UTDB_PASSWORD usertracking
ENV UTDB DATABASE userstracking
ENV GNCENG https://github.com/csgf/grid-and-cloud-engine.git
ENV GNCENG_BRANCH FutureGateway
RUN git clone $GNCENG -b $GNCENG_BRANCH
# Configure FutureGateway Database creation script to use values
# specified in the environment variables:
#
# FGDB_NAME     Database name
# FGDB_USER     Database username  
# FGDB_PASSWD   Database user password
#
RUN sed -i "s/drop\ database\ if\ exists\ fgapiserver;/drop\ database\ if\ exists\ $FGDB_NAME;/"  fgAPIServer/fgapiserver_db.sql
RUN sed -i "s/create\ database\ fgapiserver;/create\ database\ $FGDB_NAME;/" fgAPIServer/fgapiserver_db.sql
RUN sed -i "s/create\ user\ 'fgapiserver'\@'%'/create\ user\ '$FGDB_USER'\@'%'/" fgAPIServer/fgapiserver_db.sql
RUN sed -i "s/alter\ user\ 'fgapiserver'\@'%'\ identified\ by\ \"fgapiserver_password\";/alter\ user\ 'fgapiserver'\@'%'\ identified\ by\ \"$FGDB_PASSWD\";/" fgAPIServer/fgapiserver_db.sql
RUN sed -i "s/on\ fgapiserver.\*/on\ $FGDB_NAME.\*/" fgAPIServer/fgapiserver_db.sql
RUN sed -i "s/to\ 'fgapiserver'\@'%'/to\ '$FGDB_USER'\@'%'/" fgAPIServer/fgapiserver_db.sql 

RUN sed -i "s/create\ user\ 'fgapiserver'\@'localhost'/create\ user\ '$FGDB_USER'\@'localhost'/" fgAPIServer/fgapiserver_db.sql
RUN sed -i "s/alter\ user\ 'fgapiserver'\@'localhost'\ identified\ by\ \"fgapiserver_password\";/alter\ user\ 'fgapiserver'\@'localhost'\ identified\ by\ \"$FGDB_PASSWD\";/" fgAPIServer/fgapiserver_db.sql
RUN sed -i "s/on\ fgapiserver.\*/on\ $FGDB_NAME.\*/" fgAPIServer/fgapiserver_db.sql
RUN sed -i "s/to\ 'fgapiserver'\@'localhost'/to\ '$FGDB_USER'\@'localhost'/" fgAPIServer/fgapiserver_db.sql

# FutureGateway scripts
RUN git clone $FGDB_GIT -b $FGDB_BRANCH
RUN mkdir -p .fgprofile
RUN cp fgSetup/scripts/commons .fgprofile/commons
RUN cp fgSetup/scripts/fgdb .fgprofile/fgdb
RUN cp fgSetup/scripts/ei_gridengine .fgprofile/ei_gridengine
# Configure scripts
RUN sed -i "s/export FGDB_HOST=/export FGDB_HOST=$(hostname)/" .fgprofile/fgdb
RUN sed -i "s/export FGDB_PORT=/export FGDB_PORT=$FGDB_PORT/" .fgprofile/fgdb
RUN sed -i "s/export FGDB_USER=/export FGDB_USER=$FGDB_USER/" .fgprofile/fgdb
RUN sed -i "s/export FGDB_PASSWD=/export FGDB_PASSWD=$FGDB_PASSWD/" .fgprofile/fgdb
RUN sed -i "s/export FGDB_NAME=/export FGDB_NAME=$FGDB_NAME/" .fgprofile/fgdb
RUN sed -i "s/export ASDB_OPTS=/export ASDB_OPTS=''/" .fgprofile/fgdb
RUN sed -i "s/export FGDB_ROOTPWD=/export FGDB_ROOTPWD=$MYSQL_ROOT_PASSWORD/" .fgprofile/fgdb

# Working directory
USER root
#RUN sed -i "s/#bind-address\t=\ 127.0.0.1/bind-address     =\ 127.0.0.1/" /etc/mysql/mysql.conf.d/mysqld.cnf
RUN cat $FG_DIR/fgAPIServer/fgapiserver_db.sql > /docker-entrypoint-initdb.d/dbsetup.sql
RUN cat $FG_DIR/grid-and-cloud-engine/UsersTrackingDB/UsersTrackingDB.sql >> /docker-entrypoint-initdb.d/dbsetup.sql

# FGDB mySQL port available to the world outside this container
EXPOSE FGDB_PORT 


