DOCKER_REPO = futuregateway
IMAGE_NAME = fgdb
IMAGE_TAG = 0.1
FG_NETWORK = fgnetwork
FG_MYSQLIR = $$HOME/fgVolumes/fgdb_mysql
#IMAGE_LATEST_ID = $(shell docker image list | grep $(DOCKER_REPO)/$(IMAGE_NAME) | grep latest | awk '{ print $3 }')
#IMAGE_TAGGED_ID = $(shell docker image list | grep $(DOCKER_REPO)/$(IMAGE_NAME) | grep $(IMAGE_TAG) | awk '{ print $3 }')
FG_RUN_NET = $(shell docker network list --format '{{.Name}}' | grep $(FG_NETWORK))

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
	@[ -d $(FG_MYSQLIR) ] && echo "fgdb' mysql directory exists"\
                                  || mkdir -p $(FG_MYSQLIR)

run: network shdir
	docker run -d\
		   --net $(FG_NETWORK)\
		   --name $(IMAGE_NAME)_$(IMAGE_TAG)\
	           -p 3306:3306\
		   -h fgdb \
		   -v $$HOME/fgVolumes/fgdb_mysql:/var/lib/mysql\
	   	   $(DOCKER_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
