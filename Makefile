NAMESPACE = "tobinquadros"
IMAGE_NAME = "clearance"
DB_NAME = "clearance"
IMAGE_TAG ?= "latest" # If not set

.PHONY: build up db-seed

build:
	docker build -t $(NAMESPACE)/$(IMAGE_NAME):$(IMAGE_TAG) .

up: build db-seed
	docker-compose up -d

db-seed:
	docker-compose up -d db
	@sleep 5 # TODO: fix this race
	docker-compose exec db psql -U postgres -f ./data/setup.sql -d $(DB_NAME)
