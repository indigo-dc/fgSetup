# OS
FROM tiangolo/uwsgi-nginx-flask:python2.7

# Maintainer
MAINTAINER Riccardo Bruno <riccardo.bruno@ct.infn.it>

# Environment
ENV FG_USER futuregateway
ENV FG_DIR /home/futuregateway
ENV MYSQL_USER fgapiserver
ENV MYSQL_PASSWORD fgapiserver_password
ENV MYSQL_DATABASE fgapiserver
ENV FGDB_GIT https://github.com/indigo-dc/fgAPIServer.git
ENV FGDB_BRANCH safe_transaction

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
RUN git clone $FGDB_GIT -b $FGDB_BRANCH

# Use below commands for local testing
#RUN rm -rf fgAPIServer/fgapiserver.py
#RUN rm -rf fgAPIServer/requirements.txt
#ADD fgapiserver.py fgAPIServer/fgapiserver.py
#ADD client_secrets.json fgAPIServer/client_secrets.json
#ADD requirements.txt fgAPIServer/requirements.txt
#ADD cert.pem fgAPIServer/cert.pem
#ADD key.pem fgAPIServer/key.pem
#ADD fgapiserver.conf fgAPIServer/fgapiserver.conf

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
   #sed -i "s/fgapisrv_db_host\ =\ localhost/fgapisrv_db_host\ =\ fgdb/" fgapiserver.conf &&\
    cp /app_orig/uwsgi.ini uwsgi.ini &&\
    pip install -r requirements.txt
