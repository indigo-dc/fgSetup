# OS
FROM ubuntu 

# Maintainer
MAINTAINER Riccardo Bruno <riccardo.bruno@ct.infn.it>

# Environment for FGDB
ENV FG_USER futuregateway
ENV FG_USERPWD futuregateway
ENV FG_DIR /home/futuregateway
ENV FG_TEST fgtest
ENV FG_TESTPWD fgtest
ENV FG_TESTDIR /home/fgtest
ENV FGDB_HOST fgdb 
ENV FGDB_PORT 3306
ENV FGDB_USER fgapiserver
ENV FGDB_PASSWD fgapiserver_password
ENV FGDB_NAME fgapiserver
# Environment for scripts
ENV FGSETUP_GIT https://github.com/FutureGatewayFramework/fgSetup.git
ENV FGSETUP_BRANCH master
# Environment for GridEngine EI
ENV UTDB_HOST $FGDB_HOST 
ENV UTDB_PORT 3306
ENV UTDB_USER tracking_user
ENV UTDB_PASSWORD usertracking
ENV UTDB DATABASE userstracking

# Package Installation and TeSS cloning
RUN adduser --disabled-password --gecos "" $FG_USER &&\
    chown -R $FG_USER:$FG_USERS $FG_DIR &&\
    echo "$FG_USER:$FG_USERPWD" | /usr/sbin/chpasswd &&\
    adduser --disabled-password --gecos "" $FG_TEST &&\
    chown -R $FG_TEST:$FG_TEST $FG_TESTDIR &&\
    echo "$FG_TEST:$FG_TESTPWD" | /usr/sbin/chpasswd &&\
    apt-get update &&\
    apt-get install\
            -y\
            --no-install-recommends\
            ca-certificates\
            sudo\
            git\
            mysql-client\
            mlocate\
            vim\
            openssh-server\
            locales &&\
   #sudo echo "$FG_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    locale-gen en_US.UTF-8 &&\
    sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config &&\
    echo "for f in \$(find $FG_DIR/.fgprofile -type f); do source \$f; done # FGLOADENV" >> /etc/profile.d/fgdb.sh

# User and working directory
USER $FG_USER
WORKDIR $FG_DIR

# FutureGateway scripts
RUN git clone $FGSETUP_GIT -b $FGSETUP_BRANCH &&\
    mkdir -p .fgprofile &&\
    cp fgSetup/scripts/commons .fgprofile/commons &&\
    cp fgSetup/scripts/fgdb .fgprofile/fgdb &&\
    cp fgSetup/scripts/ei_gridengine .fgprofile/ei_gridengine &&\
# Configure scripts
    sed -i "s/.*FGDB_HOST.*/export FGDB_HOST=$FGDB_HOST/" .fgprofile/fgdb &&\
    sed -i "s/.*FGDB_PORT.*/export FGDB_PORT=$FGDB_PORT/" .fgprofile/fgdb &&\
    sed -i "s/.*FGDB_USER.*/export FGDB_USER=$FGDB_USER/" .fgprofile/fgdb &&\
    sed -i "s/.*FGDB_PASSWD.*/export FGDB_PASSWD=$FGDB_PASSWD/" .fgprofile/fgdb &&\
    sed -i "s/.*FGDB_NAME.*/export FGDB_NAME=$FGDB_NAME/" .fgprofile/fgdb &&\
    sed -i "s/.*ASDB_OPTS.*/export ASDB_OPTS=''/" .fgprofile/fgdb &&\
    sed -i "s/.*FGDB_ROOTPWD.*/export FGDB_ROOTPWD=$MYSQL_ROOT_PASSWORD/" .fgprofile/fgdb 

#
# Additional setup for Executor Interfaces
#

# Grid and Cloud Engine UsersTracking database
RUN sed -i "s/.*UTDB_HOST.*/export UTDB_HOST=$UTDB_HOST/" .fgprofile/ei_gridengine &&\
    sed -i "s/.*UTDB_PORT.*/export UTDB_PORT=$UTDB_PORT/" .fgprofile/ei_gridengine &&\
#    sed -i "s/.*UTDB_USER.*/export UTDB_USER=$UTDB_USER/" .fgprofile/ei_gridengine &&\
#    sed -i "s/.*UTDB_PASSWD.*/export UTDB_PASSWD=$UTDB_PASSWD/" .fgprofile/ei_gridengine &&\
#    sed -i "s/.*UTDB_NAME.*/export UTDB_NAME=$UTDB_NAME/" .fgprofile/ei_gridengine &&\
    sed -i "s/.*UTDB_OPTS.*/export UTDB_OPTS=''/" .fgprofile/ei_gridengine

# Prepare and execute sshd
USER root
WORKDIR /root
RUN  mkdir -p /var/run/sshd
ENTRYPOINT [ "/usr/sbin/sshd", "-D" ]  

