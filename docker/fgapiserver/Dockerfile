# OS
FROM tiangolo/uwsgi-nginx-flask:python2.7

# Maintainer
MAINTAINER Riccardo Bruno <riccardo.bruno@ct.infn.it>

# Environment for fgAPIServer
ENV FG_USER futuregateway
ENV FG_DIR /home/futuregateway
ENV FGAPISERVER_GIT https://github.com/FutureGatewayFramework/fgAPIServer.git 
ENV FGAPISERVER_BRANCH master
# Environment for fgdb
ENV MYSQL_ROOT_PASSWORD rpass
ENV FGDB_HOST fgdb 
ENV FGDB_PORT 3306
ENV FGDB_USER fgapiserver
ENV FGDB_PASSWD fgapiserver_password
ENV FGDB_NAME fgapiserver
# Environment for ei_gridengine EI
ENV UTDB_HOST $FGDB_HOST 
ENV UTDB_PORT 3306
ENV UTDB_USER tracking_user
ENV UTDB_PASSWORD usertracking
ENV UTDB DATABASE userstracking
# Environment for scripts
ENV FGSETUP_GIT https://github.com/FutureGatewayFramework/fgSetup.git
ENV FGSETUP_BRANCH master
# Environment for fgAPIServer configuration
ENV FGAPIVER v1.0
ENV FGAPISERVER_NAME API Server
ENV FGAPISRV_HOST 0.0.0.0
ENV FGAPISRV_PORT 8888
ENV FGAPISRV_DEBUG True
ENV FGAPISRV_IOSANDBOX \\/tmp
ENV FGAPISRV_GEAPPID 10000
ENV FGJSON_INDENT 4
ENV FGAPISRV_KEY ''
ENV FGAPISRV_CRT ''
ENV FGAPISRV_LOGCFG fgapiserver_log.conf
ENV FGAPISRV_DBVER 0.0.11
ENV FGAPISRV_SECRET 0123456789ABCDEF
ENV FGAPISRV_NOTOKEN False 
ENV FGAPISRV_NOTOKENUSR test
ENV FGAPISRV_LNKPTVFLAG True
ENV FGAPISRV_PTVENDPOINT http:\\/\\/localhost:8889\\/checktoken
ENV FGAPISRV_PTVUSER tokenver_user
ENV FGAPISRV_PTVPASS tokenver_pass
ENV FGAPISRV_PTVDEFUSR futuregateway
ENV FGAPISRV_PTVDEFGRP administrator
ENV FGAPISRV_PTVMAPFILE fgapiserver_ptvmap.json
ENV FGAPISRV_DB_HOST $FGDB_HOST
ENV FGAPISRV_DB_PORT $FGDB_PORT 
ENV FGAPISRV_DB_USER $FGDB_USER
ENV FGAPISRV_DB_PASS $FGDB_PASSWD 
ENV FGAPISRV_DB_NAME $FGDB_NAME

# User and working directory
WORKDIR $FG_DIR

# Package Installation and TeSS cloning
RUN adduser --disabled-password --gecos "" $FG_USER &&\
    chown -R $FG_USER:$FG_USERS $FG_DIR &&\
    apt-get update &&\
    apt-get install -y --no-install-recommends ca-certificates\
    mysql-client sudo git mlocate vim &&\
    sudo echo "$FG_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

# User and working directory
USER $FG_USER
WORKDIR $FG_DIR

# Getting FG repo
RUN git clone $FGAPISERVER_GIT -b $FGAPISERVER_BRANCH

# Use below commands for local testing
#RUN rm -rf fgAPIServer/fgapiserver.py
#RUN rm -rf fgAPIServer/requirements.txt
#ADD fgapiserver.py fgAPIServer/fgapiserver.py
#ADD client_secrets.json fgAPIServer/client_secrets.json
#ADD requirements.txt fgAPIServer/requirements.txt
#ADD cert.pem fgAPIServer/cert.pem
#ADD key.pem fgAPIServer/key.pem
#ADD fgapiserver.conf fgAPIServer/fgapiserver.conf


# FutureGateway scripts
RUN git clone $FGSETUP_GIT -b $FGSETUP_BRANCH &&\
    mkdir -p .fgprofile &&\
    cp fgSetup/scripts/commons .fgprofile/commons &&\
    cp fgSetup/scripts/fgdb .fgprofile/fgdb &&\
    cp fgSetup/scripts/fgdb .fgprofile/fgapiserver &&\
    cp fgSetup/scripts/ei_gridengine .fgprofile/ei_gridengine &&\
# Configure scripts
    sed -i "s/export FGDB_HOST=/export FGDB_HOST=$FGDB_HOST/" .fgprofile/fgdb &&\
    sed -i "s/export FGDB_PORT=/export FGDB_PORT=$FGDB_PORT/" .fgprofile/fgdb &&\
    sed -i "s/export FGDB_USER=/export FGDB_USER=$FGDB_USER/" .fgprofile/fgdb &&\
    sed -i "s/export FGDB_PASSWD=/export FGDB_PASSWD=$FGDB_PASSWD/" .fgprofile/fgdb &&\
    sed -i "s/export FGDB_NAME=/export FGDB_NAME=$FGDB_NAME/" .fgprofile/fgdb &&\
    sed -i "s/export ASDB_OPTS=/export ASDB_OPTS=''/" .fgprofile/fgdb &&\
    sed -i "s/export FGDB_ROOTPWD=/export FGDB_ROOTPWD=$MYSQL_ROOT_PASSWORD/" .fgprofile/fgdb &&\
# Configuring scripts ei_gridengine
    sed -i "s/export UTDB_HOST=/export UTDB_HOST=$UTDB_HOST/" .fgprofile/ei_gridengine &&\
    sed -i "s/export UTDB_PORT=/export UTDB_PORT=$UTDB_PORT/" .fgprofile/ei_gridengine &&\
#    sed -i "s/export UTDB_USER=/export UTDB_USER=$UTDB_USER/" .fgprofile/ei_gridengine &&\
#    sed -i "s/export UTDB_PASSWD=/export UTDB_PASSWD=$UTDB_PASSWD/" .fgprofile/ei_gridengine &&\
#    sed -i "s/export UTDB_NAME=/export UTDB_NAME=$UTDB_NAME/" .fgprofile/ei_gridengine &&\
    sed -i "s/export UTDB_OPTS=/export UTDB_OPTS=''/" .fgprofile/ei_gridengine


# nginx port 80 available to the world outside this container
EXPOSE 80 

# Back to the root user
USER root

# Configure the webapp
RUN cp -r fgAPIServer/ / &&\
    mv /app /app_orig &&\
    mv /fgAPIServer /app &&\
    mkdir /app/iosandbox

WORKDIR /app

RUN ln -s fgapiserver.py main.py &&\
    sed -i "s/.*fgapiver.*/fgapiver = $FGAPIVER/" fgapiserver.conf &&\
    sed -i "s/.*fgapiserver_name.*/fgapiserver_name = $FGAPISERVER_NAME/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_host.*/fgapisrv_host = $FGAPISRV_HOST/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_port.*/fgapisrv_port = $FGAPISRV_PORT/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_debug.*/fgapisrv_debug = $FGAPISRV_DEBUG/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_iosandbox.*/fgapisrv_iosandbox = $FGAPISRV_IOSANDBOX/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_geappid.*/fgapisrv_geappid = $FGAPISRV_GEAPPID/" fgapiserver.conf &&\
    sed -i "s/.*fgjson_indent.*/fgjson_indent = $FGJSON_INDENT/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_key.*/fgapisrv_key = $FGAPISRV_KEY/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_crt.*/fgapisrv_crt = $FGAPISRV_CRT/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_logcfg.*/fgapisrv_logcfg = $FGAPISRV_LOGCFG/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_dbver.*/fgapisrv_dbver = $FGAPISRV_DBVER/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_secret.*/fgapisrv_secret = $FGAPISRV_SECRET/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_notoken.*/fgapisrv_notoken = $FGAPISRV_NOTOKEN/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_notokenusr.*/fgapisrv_notokenusr = $FGAPISRV_NOTOKENUSR/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_lnkptvflag.*/fgapisrv_lnkptvflag = $FGAPISRV_LNKPTVFLAG/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_ptvendpoint.*/fgapisrv_ptvendpoint = $FGAPISRV_PTVENDPOINT/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_ptvuser.*/fgapisrv_ptvuser = $FGAPISRV_PTVUSER/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_ptvpass.*/fgapisrv_ptvpass = $FGAPISRV_PTVPASS/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_ptvdefusr.*/fgapisrv_ptvdefusr = $FGAPISRV_PTVDEFUSR/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_ptvdefgrp.*/fgapisrv_ptvdefgrp = $FGAPISRV_PTVDEFGRP/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_ptvmapfile.*/fgapisrv_ptvmapfile = $FGAPISRV_PTVMAPFILE/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_db_host.*/fgapisrv_db_host = $FGAPISRV_DB_HOST/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_db_port.*/fgapisrv_db_port = $FGAPISRV_DB_PORT/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_db_user.*/fgapisrv_db_user = $FGAPISRV_DB_USER/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_db_pass.*/fgapisrv_db_pass = $FGAPISRV_DB_PASS/" fgapiserver.conf &&\
    sed -i "s/.*fgapisrv_db_name.*/fgapisrv_db_name = $FGAPISRV_DB_NAME/" fgapiserver.conf &&\
    cp /app_orig/uwsgi.ini uwsgi.ini &&\
    pip install -r requirements.txt
