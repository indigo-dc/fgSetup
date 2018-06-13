DOCKER_REPO = futuregateway
IMAGE_NAME = fgapiserver
IMAGE_TAG = 0.1
FG_NETWORK = fgnetwork
FG_VOLUMEDIR = $$HOME/fgVolumes
#FG_APPSDIR = $$HOME/fgVolumes/apps
FG_IOSANDBOXDIR = $(FG_VOLUMEDIR)/iosandbox
FG_APISERVERDIR = $(FG_VOLUMEDIR)/fgAPIServer
FG_APISERVERGIT = https://github.com/FutureGatewayFramework/fgAPIServer.git

# Environmnt for fgapiserver.conf
# Used only in the case of 'testrun' recipe
FGDB_HOST = fgdb
FGDB_PORT = 3306
FGDB_USER = fgapiserver
FGDB_PASSWD = fgapiserver_password
FGDB_NAME = fgapiserver
FGAPIVER = v1.0
FGAPISERVER_NAME = API Server
FGAPISRV_HOST = 0.0.0.0
FGAPISRV_PORT = 8888
FGAPISRV_DEBUG = True
FGAPISRV_IOSANDBOX = \\/app\\/fgiosandbox
FGAPISRV_GEAPPID = 10000
FGJSON_INDENT = 4
FGAPISRV_KEY =
FGAPISRV_CRT =
FGAPISRV_LOGCFG = fgapiserver_log.conf
FGAPISRV_DBVER = 0.0.11
FGAPISRV_SECRET = 0123456789ABCDEF
FGAPISRV_NOTOKEN = False
FGAPISRV_NOTOKENUSR = test
FGAPISRV_LNKPTVFLAG = True
FGAPISRV_PTVENDPOINT = http:\\/\\/localhost:8889\\/checktoken
FGAPISRV_PTVUSER = tokenver_user
FGAPISRV_PTVPASS = tokenver_pass
FGAPISRV_PTVDEFUSR = futuregateway
FGAPISRV_PTVDEFGRP = administrator
FGAPISRV_PTVMAPFILE = fgapiserver_ptvmap.json
FGAPISRV_DB_HOST = $(FGDB_HOST)
FGAPISRV_DB_PORT = $(FGDB_PORT)
FGAPISRV_DB_USER = $(FGDB_USER)
FGAPISRV_DB_PASS = $(FGDB_PASSWD)
FGAPISRV_DB_NAME = $(FGDB_NAME)

default:
	@echo "Usage: make <image|pubimg>"
	@echo "     image - Build the image: $(DOCKER_REPO)/$(IMAGE_NAME):latest"
	@echo "       run - Create container from image : $(DOCKER_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)"
	@echo "             having name: $(IMAGE_NAME)_$(IMAGE_TAG)" 
	@echo "   publish - Publish images: $(DOCKER_REPO)/$(IMAGE_NAME):latest"
	@echo "                             $(DOCKER_REPO)/$(IMAGE_NAME):$(IMAGE:_TAG)"
	@echo "             on the Docker-hub"
	@echo ""
	#@echo "Latest image: $(IMAGE_LATEST_ID)"
	#@echo "Tagged image: $(IMAGE_TAG) - $(IMAGE_TAGGED_ID)"	

image: Dockerfile
	docker build --no-cache  -t $(DOCKER_REPO)/$(IMAGE_NAME):latest .
	docker tag $(DOCKER_REPO)/$(IMAGE_NAME):latest $(DOCKER_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

publish: image 
	docker push $(DOCKER_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(DOCKER_REPO)/$(IMAGE_NAME):latest

network:
	@[ "$(shell docker network list | grep $(FG_NETWORK))" = "" ]\
	       	&& docker network create $(FG_NETWORK)\
                || echo "Network $(FG_NETWORK) already running"

shdir:
	@echo [ -d $(FG_APPSDIR) ] && echo "fgapiserver' apps directory exists"\
                                  || mkdir -p $(FG_APPSDIR)/apps
	@[ -d $(FG_IOSANDBOXDIR) ] && echo "fgapiserver' iosandbox directory exists"\
                                  || mkdir -p $(FG_IOSANDBOXDIR)
test_shdir:
	@[ -d $(FG_APISERVERDIR) ] && echo "fgapiserver' iosandbox directory exists"\
                                  || mkdir -p $(FG_APISERVERDIR)
	@[ -d $(FG_IOSANDBOXDIR) ] && echo "fgapiserver' iosandbox directory exists"\
                                  || mkdir -p $(FG_IOSANDBOXDIR)
	sudo rm -rf $(FG_APISERVERDIR) &&\
	cd $(FG_VOLUMEDIR) &&\
       	git clone $(FG_APISERVERGIT) &&\
	cd - &&\
	cd $(FG_APISERVERDIR) &&\
	ln -s fgapiserver.py main.py &&\
	echo "[uwsgi]" > uwsgi.ini &&\
        echo "module = main" >> uwsgi.ini &&\
        echo "callable = app" >> uwsgi.ini &&\
        sed -i "s/^fgapiver.*/fgapiver = $(FGAPIVER)/" fgapiserver.conf &&\
        sed -i "s/^fgapiserver_name.*/fgapiserver_name = $(FGAPISERVER_NAME)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_host.*/fgapisrv_host = $(FGAPISRV_HOST)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_port.*/fgapisrv_port = $(FGAPISRV_PORT)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_debug.*/fgapisrv_debug = $(FGAPISRV_DEBUG)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_iosandbox.*/fgapisrv_iosandbox = $(FGAPISRV_IOSANDBOX)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_geappid.*/fgapisrv_geappid = $(FGAPISRV_GEAPPID)/" fgapiserver.conf &&\
        sed -i "s/^fgjson_indent.*/fgjson_indent = $(FGJSON_INDENT)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_key.*/fgapisrv_key = $(FGAPISRV_KEY)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_crt.*/fgapisrv_crt = $(FGAPISRV_CRT)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_logcfg.*/fgapisrv_logcfg = $(FGAPISRV_LOGCFG)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_dbver.*/fgapisrv_dbver = $(FGAPISRV_DBVER)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_secret.*/fgapisrv_secret = $(FGAPISRV_SECRET)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_notoken\ .*/fgapisrv_notoken = $(FGAPISRV_NOTOKEN)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_notokenusr.*/fgapisrv_notokenusr = $(FGAPISRV_NOTOKENUSR)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_lnkptvflag.*/fgapisrv_lnkptvflag = $(FGAPISRV_LNKPTVFLAG)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_ptvendpoint.*/fgapisrv_ptvendpoint = $(FGAPISRV_PTVENDPOINT)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_ptvuser.*/fgapisrv_ptvuser = $(FGAPISRV_PTVUSER)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_ptvpass.*/fgapisrv_ptvpass = $(FGAPISRV_PTVPASS)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_ptvdefusr.*/fgapisrv_ptvdefusr = $(FGAPISRV_PTVDEFUSR)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_ptvdefgrp.*/fgapisrv_ptvdefgrp = $(FGAPISRV_PTVDEFGRP)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_ptvmapfile.*/fgapisrv_ptvmapfile = $(FGAPISRV_PTVMAPFILE)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_db_host.*/fgapisrv_db_host = $(FGAPISRV_DB_HOST)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_db_port.*/fgapisrv_db_port = $(FGAPISRV_DB_PORT)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_db_user.*/fgapisrv_db_user = $(FGAPISRV_DB_USER)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_db_pass.*/fgapisrv_db_pass = $(FGAPISRV_DB_PASS)/" fgapiserver.conf &&\
        sed -i "s/^fgapisrv_db_name.*/fgapisrv_db_name = $(FGAPISRV_DB_NAME)/" fgapiserver.conf &&\
	cd -

run: network shdir
	@FGDB_IP=`docker network inspect fgnetwork|\
		jq '.[].Containers[]|select(.Name|contains("fgdb"))|.IPv4Address'|\
		xargs echo| sed 's/\// /' | awk '{ print $$1 }'` &&\
        [ "$$FGDB_IP" != "" ] &&\
        echo "fgdb IP: $$FGDB_IP" &&\
        docker run -d\
	    -e FGDB_HOST=$(FG_RUN_NET)\
            --net $(FG_NETWORK)\
            --name $(IMAGE_NAME)_$(IMAGE_TAG)\
            -p8888:80\
            -p8889:8889\
	    --add-host "fgdb:$$FGDB_IP"\
	    -v $(FG_APPSDIR):/app/apps\
	    -v $(FG_IOSANDBOXDIR):/tmp/fgiosandbox\
	    -h fgapiserver\
	    $(DOCKER_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) ||\
        echo "Sorry, FGDB node is not running!"

testrun: network test_shdir
	@FGDB_IP=`docker network inspect fgnetwork|\
                jq '.[].Containers[]|select(.Name|contains("fgdb"))|.IPv4Address'|\
                xargs echo| sed 's/\// /' | awk '{ print $$1 }'` &&\
        [ "$$FGDB_IP" != "" ] &&\
        echo "fgdb IP: $$FGDB_IP" &&\
        docker run -d\
            -e FGDB_HOST=$(FG_RUN_NET)\
	    -e FLASK_APP=main.py\
	    -e FLASK_DEBUG=1\
            --net $(FG_NETWORK)\
            --name $(IMAGE_NAME)_test_$(IMAGE_TAG)\
            -p8888:80\
            -p8889:8889\
            --add-host "fgdb:$$FGDB_IP"\
            -v $(FG_APISERVERDIR):/app\
	    -v $(FG_IOSANDBOXDIR):/tmp/fgiosandbox\
	    -h fgapiserver_test\
            $(DOCKER_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)\
	    bash -c "while true ; do sleep 10 ; done" ||\
        echo "Sorry, FGDB node is not running!"
