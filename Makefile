include .env

# Used to name the final docker image artifact
FULL_IMAGE_NAME := $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE_NAME)

# Allows reusing the docker-compose network with vanilla `docker run`
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))
DOCKER_COMPOSE_NETWORK := "$(shell echo $(CURRENT_DIR) | tr A-Z a-z | tr -d - | tr -d _)_default"

.PHONY: local-dev
local-dev:
	@docker-compose up

.PHONY: tests
tests:
	@docker-compose run --rm -e ENV=test app bin/run_tests

.PHONY: restart
restart:
	@docker-compose restart app

.PHONY: db
db:
	@docker-compose up -d db

.PHONY: build
build:
	@docker image build -t $(FULL_IMAGE_NAME) .

.PHONY: mock
mock: db build
	@docker run $(MOCK_DOCKER_ARGS) \
		--env-file ".env" \
		--network $(DOCKER_COMPOSE_NETWORK) \
		-p $(HTTP_PORT):$(HTTP_PORT) \
		--name "mock_$(DOCKER_IMAGE_NAME)" \
		$(FULL_IMAGE_NAME)

.PHONY: check
check: clean
	@$(MAKE) mock MOCK_DOCKER_ARGS='-d'
	@bin/check $(HTTP_PORT)
	@$(MAKE) clean

# ============================================================================= 
# Helpers
# ==============================================================================

.PHONY: app-shell
app-shell:
	@docker-compose exec app bash

.PHONY: db-setup
db-setup: db
	@docker-compose exec db psql -U $(POSTGRES_USER) -d $(POSTGRES_DATABASE) -f ./data/setup.sql

.PHONY: db-shell
db-shell: db
	@sleep 1  # allow db container to initialize
	@docker-compose exec db psql -U $(POSTGRES_USER)

.PHONY: clean
clean: rm-containers rm-images
	-@docker-compose down --remove-orphans --volumes

.PHONY: rm-containers
rm-containers:
	-@ docker container ls -aq -f "status=running" | xargs -I {} docker container kill {}
	-@docker container prune --force

.PHONY: rm-images
rm-images:
	-@docker image prune --force

