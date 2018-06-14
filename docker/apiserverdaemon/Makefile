DOCKER_REPO = futuregateway
IMAGE_NAME = apiserverdaemon
IMAGE_TAG = 0.1
FG_NETWORK = fgnetwork
FG_APISRVVOLNAME = fg_apiserver
FG_APPSDIRVOLNAME = fg_apps
FG_IOSNDBXVOLNAME = fg_iosandbox

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
	docker build\
               --no-cache\
               -t $(DOCKER_REPO)/$(IMAGE_NAME):latest .
	docker tag $(DOCKER_REPO)/$(IMAGE_NAME):latest $(DOCKER_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

publish: image 
	docker push $(DOCKER_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(DOCKER_REPO)/$(IMAGE_NAME):latest

network:
	@[ "$(shell docker network list | grep $(FG_NETWORK))" = "" ]\
                && docker network create $(FG_NETWORK)\
                || echo "Network $(FG_NETWORK) already running"

volumes:
	@FGAPPSVOL=`docker volume inspect  $(FG_APPSDIRVOLNAME) 2>/dev/null | jq '.[].Mountpoint' | xargs echo` &&\
	[ -z "$$FGAPPSVOL" ] &&\
	       	docker volume create $(FG_APPSDIRVOLNAME) ||\
	       	echo "FG apps volume exists at: $$FG_APPSDIRVOL" &&\
	FGIOSBSVOL=`docker volume inspect  $(FG_IOSNDBXVOLNAME) 2>/dev/null | jq '.[].Mountpoint' | xargs echo` &&\
	[ -z "$$FGIOSBSVOL" ] &&\
	       	docker volume create $(FG_IOSNDBXVOLNAME) ||\
                echo "FG apps volume exists at: $$FGIOSBSVOL"

run: network volumes 
	FGDB_IP=`docker network inspect fgnetwork|\
		jq '.[].Containers[]|select(.Name|contains("fgdb"))|.IPv4Address'|\
		xargs echo| sed 's/\// /' | awk '{ print $$1 }'` &&\
	FGTEST_IP=`docker network inspect fgnetwork|\
	        jq '.[].Containers[]|select(.Name|contains("sshnode"))|.IPv4Address'|\
		xargs echo| sed 's/\// /' | awk '{ print $$1 }'` &&\
        [ "$$FGDB_IP" != "" -a "$$FGTEST_IP" != "" ] &&\
        echo "fgdb IP: $$FGDB_IP" &&\
        docker run -d\
	    -e FGDB_HOST=$(FG_RUN_NET)\
            --net $(FG_NETWORK)\
            --name $(IMAGE_NAME)_$(IMAGE_TAG)\
            -p8088:8080\
	    --add-host "fgdb:$$FGDB_IP"\
	    --add-host "fgtest:$$FGTEST_IP"\
	    -v $(FG_APPSDIRVOLNAME):/app/apps\
	    -v $(FG_IOSNDBXVOLNAME):/tmp/fgiosandbox\
	    -h apiserverdaemon\
	    $(DOCKER_REPO)/$(IMAGE_NAME):$(IMAGE_TAG) ||\
        echo "Sorry, one of the nodes FGDB or FGTEST is not running!"
