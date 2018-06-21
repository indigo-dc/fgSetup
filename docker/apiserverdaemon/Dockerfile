# OS
FROM tomcat:7

# Maintainer
MAINTAINER Riccardo Bruno <riccardo.bruno@ct.infn.it>

# Environment
ENV FG_USER futuregateway
ENV FG_DIR /home/futuregateway
ENV MYSQL_HOST fgdb
ENV MYSQL_PORT 3306
ENV MYSQL_USER fgapiserver
ENV MYSQL_PASSWORD fgapiserver_password
ENV MYSQL_DATABASE fgapiserver
ENV FGDB_GIT https://github.com/FutureGatewayFramework/APIServerDaemon.git
ENV FGDB_BRANCH master 
ENV TOMCAT_USER tomcat
ENV TOMCAT_PASSWORD tomcat__pass
ENV FGAPISRV_IOSANDBOX /app/fgiosandbox
# Environment for scripts
ENV FGSETUP_GIT https://github.com/FutureGatewayFramework/fgSetup.git
ENV FGSETUP_BRANCH master
# Environment for fgdb
ENV MYSQL_ROOT_PASSWORD rpass
ENV FGDB_HOST fgdb 
ENV FGDB_PORT 3306
ENV FGDB_USER fgapiserver
ENV FGDB_PASSWD fgapiserver_password
ENV FGDB_NAME fgapiserver
# Executor Interfaces environment
ENV UTDB_HOST fgdb
ENV UTDB_PORT 3306
ENV UTDB_USER tracking_user
ENV UTDB_PASSWORD usertracking
ENV UTDB_DATABASE userstracking
ENV GNCENG_ADP_ROCCI https://github.com/csgf/jsaga-adaptor-rocci.git
ENV GNCENG_ADP_ROCCI_BRANCH master
ENV GNCENG https://github.com/csgf/grid-and-cloud-engine.git
ENV GNCENG_BRANCH FutureGateway

# FG User creation and packages installation
RUN adduser --disabled-password --gecos "" $FG_USER &&\
    chown -R $FG_USER:$FG_USER $FG_DIR &&\
    apt-get update &&\
    apt-get install\
            -y\
            --no-install-recommends\
            openssh-client\
            openjdk-7-jdk\
            ant\
            mysql-client\
            libmysql-java\
            procps\
            sudo\
            git\
            mlocate\
            vim\
            locales &&\
    locale-gen en_US.UTF-8 &&\
    echo "$FG_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    mkdir -p $FGAPISRV_IOSANDBOX &&\
    chown -R root:futuregateway $FGAPISRV_IOSANDBOX &&\ 
    chown -R root:futuregateway $CATALINA_HOME &&\
    chmod -R g+r+w $CATALINA_HOME &&\
    echo "for f in \$(find $FG_DIR/.fgprofile -type f); do source \$f; done # FGLOADENV" >> /etc/profile.d/fgdb.sh

# Setup Tomcat mgr user and roles
RUN mv $CATALINA_HOME/conf/tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml_orig &&\
    LN=$(cat $CATALINA_HOME/conf/tomcat-users.xml_orig | grep -n "</tomcat-users>" | awk -F":" '{ print $1 }') &&\
    ALN=$(cat $CATALINA_HOME/conf/tomcat-users.xml_orig | wc -l) &&\
    cat $CATALINA_HOME/conf/tomcat-users.xml_orig | head -n $((LN-1)) > $CATALINA_HOME/conf/tomcat-users.xml &&\
    echo "                 <role rolename=\"manager-gui\"/>" >> $CATALINA_HOME/conf/tomcat-users.xml &&\
    echo "                 <role rolename=\"manager-script\"/>" >> $CATALINA_HOME/conf/tomcat-users.xml &&\
    echo "                 <role rolename=\"tomcat\"/>" >> $CATALINA_HOME/conf/tomcat-users.xml &&\
    echo "                 <role rolename=\"liferay\"/>" >> $CATALINA_HOME/conf/tomcat-users.xml &&\
    echo "                 <user username=\"$TOMCAT_USER\" password=\"$TOMCAT_PASSWORD\" roles=\"tomcat,liferay,manager-gui,manager-script\"/>" >> $CATALINA_HOME/conf/tomcat-users.xml &&\
    cat $CATALINA_HOME/conf/tomcat-users.xml_orig | tail -n $((ALN-LN+1)) >> $CATALINA_HOME/conf/tomcat-users.xml &&\
    echo "tomcat-users.xml" &&\
    cat $CATALINA_HOME/conf/tomcat-users.xml

# mysql-connector library
RUN updatedb && MYSQL_CONNECTOR=$(locate mysql-connector-java.jar) &&\
    cd $CATALINA_HOME/lib && ln -s $MYSQL_CONNECTOR mysql-connector-java.jar

# User and working directory
USER $FG_USER
WORKDIR $FG_DIR

# Getting FG repo and setup properties files
RUN git clone $FGDB_GIT -b $FGDB_BRANCH &&\
    sed -i "s/apisrv_dbhost\ =\ localhost/apisrv_dbhost\ =\ $FGDB_HOST/"\
        APIServerDaemon/web/WEB-INF/classes/it/infn/ct/APIServerDaemon.properties &&\
    sed -i "s/utdb_host\ =\ localhost/utdb_host\ =\ $FGDB_HOST/"\
         APIServerDaemon/web/WEB-INF/classes/it/infn/ct/APIServerDaemon.properties &&\
    sed -i "s/apisrv_dbhost\ =\ localhost/apisrv_dbhost\ =\ $FGDB_HOST/"\
        APIServerDaemon/web/WEB-INF/classes/it/infn/ct/GridEngineDaemon.properties &&\
    sed -i "s/utdb_host\ =\ localhost/utdb_host\ =\ $FGDB_HOST/"\
         APIServerDaemon/web/WEB-INF/classes/it/infn/ct/GridEngineDaemon.properties &&\
    sed -i "s/localhost:8888/fgapiserver/"\
        APIServerDaemon/web/WEB-INF/classes/it/infn/ct/ToscaIDC.properties &&\
    sed -i "s/localhost:8889\\/get-token/fgapiserver:8889\\/get-token/"\
         APIServerDaemon/web/WEB-INF/classes/it/infn/ct/ToscaIDC.properties &&\
	 sed -i "s/localhost:/$FGDB_HOST:/"\
           APIServerDaemon/web/META-INF/context.xml &&\
    mkdir -p APIServerDaemon/work/WEB-INF/classes/it/infn/ct

#
# Executor Interfaces
#

# GridnCloud Engine Executor Interface
RUN sudo apt-get update &&\
    sudo apt-get install -y --no-install-recommends maven &&\
    sudo apt-get clean
# JSAGA rOCCI adaptor
RUN git clone $GNCENG_ADP_ROCCI -b $GNCENG_ADP_ROCCI_BRANCH
RUN cd jsaga-adaptor-rocci && ant all &&\
    mkdir -p ../APIServerDaemon/lib &&\
    cp dist/jsaga-adaptor-rocci.jar \
       ../APIServerDaemon/lib/jsaga-adaptor-rocci.jar
# GridnCloud Engine
RUN git clone $GNCENG -b $GNCENG_BRANCH &&\
    cd grid-and-cloud-engine/grid-and-cloud-engine_M &&\
    sed -i "s/localhost/$FGDB_HOST:$FGDB_PORT/"\
           src/main/resources/hibernateStandAlone.cfg.xml &&\
#    sed -i "s/jdbc:mysql:\/\/localhost/jdbc:mysql:\/\/$FGDB_HOST/g"\
#           src/main/resources/hibernate.cfg.xml &&\
#    sed -i "s/jdbc:mysql:\/\/localhost/jdbc:mysql:\/\/$FGDB_HOST/g"\
#           src/main/java/it/infn/ct/GridEngine/JobCollection/JobCollectionSubmission.java &&\
#    sed -i "s/jdbc:mysql:\/\/localhost/jdbc:mysql:\/\/$FGDB_HOST/g"\
#           src/main/java/it/infn/ct/GridEngine/Job/MultiInfrastructureJobSubmission.java &&\
#    sed -i "s/jdbc:mysql:\/\/localhost/jdbc:mysql:\/\/$FGDB_HOST/g"\
#           src/main/java/it/infn/ct/GridEngine/Job/JSagaJobSubmission.java &&\
#    sed -i "s/jdbc:mysql:\/\/localhost/jdbc:mysql:\/\/$FGDB_HOST/g"\
#           src/main/java/it/infn/ct/GridEngine/UsersTracking/UsersTrackingDBInterface.java &&\
    cd -

RUN cd grid-and-cloud-engine/grid-and-cloud-engine-threadpool &&\
    #mvn clean install -Dmaven.compiler.source=1.6 -Dmaven.compiler.target=1.6 &&\
    mvn install &&\
    cp target/grid-and-cloud-engine-threadpool-0.0.1-SNAPSHOT.jar \
       ../../APIServerDaemon/lib/grid-and-cloud-engine-threadpool-0.0.1-SNAPSHOT.jar &&\
    cp target/lib/*.jar ../../APIServerDaemon/lib/
RUN cd grid-and-cloud-engine/grid-and-cloud-engine_M &&\
    #mvn clean install -Dmaven.compiler.source=1.6 -Dmaven.compiler.target=1.6 &&\
    mvn install &&\
    cp target/grid-and-cloud-engine_M-0.0.1-SNAPSHOT.jar \
       ../../APIServerDaemon/lib/grid-and-cloud-engine_M-0.0.1-SNAPSHOT.jar &&\
    cp target/lib/*.jar ../../APIServerDaemon/lib/

# Setup Tomcat' connection pools for UsersTracking
RUN sudo chmod 644 $CATALINA_HOME/conf/server.xml &&\
    sudo chmod g+x /usr/local/tomcat/conf &&\
    mv $CATALINA_HOME/conf/server.xml $CATALINA_HOME/conf/server.xml_orig &&\
    LN=$(cat $CATALINA_HOME/conf/server.xml_orig | grep -n "</GlobalNamingResources>" | awk -F":" '{ print $1 }') &&\
    ALN=$(cat $CATALINA_HOME/conf/server.xml_orig | wc -l) &&\
    cat $CATALINA_HOME/conf/server.xml_orig | head -n $((LN-1)) > $CATALINA_HOME/conf/server.xml &&\
    echo "               <Resource name=\"jdbc/UserTrackingPool\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           auth=\"Container\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           type=\"javax.sql.DataSource\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           username=\"$UTDB_USER\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           password=\"$UTDB_PASSWORD\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           driverClassName=\"com.mysql.jdbc.Driver\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           url=\"jdbc:mysql://$UTDB_HOST:$UTDB_PORT/$UTDB_DATABASE\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           testOnBorrow=\"true\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           testWhileIdle=\"true\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           validationInterval=\"0\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           initialSize=\"3\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           maxTotal=\"100\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           maxIdle=\"30\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           maxWaitMillis=\"10000\"/>" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                 <Resource name=\"jdbc/gehibernatepool\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           auth=\"Container\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           type=\"javax.sql.DataSource\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           username=\"$UTDB_USER\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           password=\"$UTDB_PASSWORD\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           driverClassName=\"com.mysql.jdbc.Driver\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           url=\"jdbc:mysql://$UTDB_HOST:$UTDB_PORT/$UTDB_DATABASE\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           testOnBorrow=\"true\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           testWhileIdle=\"true\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           validationInterval=\"0\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           initialSize=\"3\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           maxTotal=\"100\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           maxIdle=\"30\"" >> $CATALINA_HOME/conf/server.xml &&\
    echo "                           maxWaitMillis=\"10000\"/>" >> $CATALINA_HOME/conf/server.xml &&\
    cat $CATALINA_HOME/conf/server.xml_orig | tail -n $((ALN-LN+1)) >> $CATALINA_HOME/conf/server.xml &&\
    echo "server.xml" &&\
    cat $CATALINA_HOME/conf/server.xml

# FutureGateway scripts
RUN git clone $FGSETUP_GIT -b $FGSETUP_BRANCH &&\
    mkdir -p .fgprofile &&\
    cp fgSetup/scripts/commons .fgprofile/commons &&\
    cp fgSetup/scripts/fgdb .fgprofile/fgdb &&\
    cp fgSetup/scripts/fgdb .fgprofile/fgapiserver &&\
    cp fgSetup/scripts/ei_gridengine .fgprofile/ei_gridengine &&\
# Configure scripts
    sed -i "s/.*FGDB_HOST.*/export FGDB_HOST=$FGDB_HOST/" .fgprofile/fgdb &&\
    sed -i "s/.*FGDB_PORT.*/export FGDB_PORT=$FGDB_PORT/" .fgprofile/fgdb &&\
    sed -i "s/.*FGDB_USER.*/export FGDB_USER=$FGDB_USER/" .fgprofile/fgdb &&\
    sed -i "s/.*FGDB_PASSWD.*/export FGDB_PASSWD=$FGDB_PASSWD/" .fgprofile/fgdb &&\
    sed -i "s/.*FGDB_NAME.*/export FGDB_NAME=$FGDB_NAME/" .fgprofile/fgdb &&\
    sed -i "s/.*ASDB_OPTS.*/export ASDB_OPTS=''/" .fgprofile/fgdb &&\
    sed -i "s/.*FGDB_ROOTPWD.*/export FGDB_ROOTPWD=$MYSQL_ROOT_PASSWORD/" .fgprofile/fgdb &&\
# Configuring scripts ei_gridengine
    sed -i "s/.*UTDB_HOST.*/export UTDB_HOST=$UTDB_HOST/" .fgprofile/ei_gridengine &&\
    sed -i "s/.*UTDB_PORT.*/export UTDB_PORT=$UTDB_PORT/" .fgprofile/ei_gridengine &&\
#    sed -i "s/.*UTDB_USER.*/export UTDB_USER=$UTDB_USER/" .fgprofile/ei_gridengine &&\
#    sed -i "s/.*UTDB_PASSWD.*/export UTDB_PASSWD=$UTDB_PASSWD/" .fgprofile/ei_gridengine &&\
#    sed -i "s/.*UTDB_NAME.*/export UTDB_NAME=$UTDB_NAME/" .fgprofile/ei_gridengine &&\
    sed -i "s/.*UTDB_OPTS.*/export UTDB_OPTS=''/" .fgprofile/ei_gridengine &&\
    cat .fgprofile/fgdb && cat .fgprofile/ei_gridengine

#
# Build APIServerDaemon WAR
#
RUN cd APIServerDaemon && mkdir -p web/WEB-INF/lib && ant all

# nginx port 80 available to the world outside this container
EXPOSE 8080

# Back to the root user
USER root 
RUN cp /home/$FG_USER/APIServerDaemon/dist/APIServerDaemon.war $CATALINA_HOME/webapps/

