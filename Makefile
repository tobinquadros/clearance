NAMESPACE = "tobinquadros"
IMAGE_NAME = "clearance"
IMAGE_TAG ?= "latest" # If not set

.PHONY: build up

build:
	docker build -t $(NAMESPACE)/$(IMAGE_NAME):$(IMAGE_TAG) .

up: build
	docker-compose up
