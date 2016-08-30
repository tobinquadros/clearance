NAMESPACE := tobinquadros
IMAGE_NAME := clearance
IMAGE_TAG ?= latest

PACKAGES := $(shell find ./* -type d | grep -v vendor/)
INSTALL_PREFIX ?= $(GOPATH)/bin/
COMMIT := $(shell git describe --always --dirty)
GOVERSION := $(shell go version)  # TODO: Set this in docker binary

# Support Linux & OSX builds
PLATFORMS := linux/amd64 darwin/amd64
temp = $(subst /, ,$@)
os = $(word 1, $(temp))
arch = $(word 2, $(temp))

# Unitialized vars must be declared in the codebase for each importpath.key set
LDFLAGS := -X 'main.buildtime=$(shell date -u +%s)-UTC' \
	-X 'main.commit=$(COMMIT)' \
	-X 'main.goversion=$(GOVERSION)'

POSTGRES_USER := clearance
POSTGRES_NAME := $(POSTGRES_USER)

.PHONY: test
test:
	go test $$(go list ./... | grep -v vendor/)

.PHONY: coverage
coverage:

.PHONY: benchmark
benchmark:
	go test -bench=. $$(go list ./... | grep -v vendor/ | grep -v cmd/)

.PHONY: docker-image
docker-image:
	docker build -t $(NAMESPACE)/$(IMAGE_NAME):$(IMAGE_TAG) .

.PHONY: docker-shell
docker-shell:
	docker-compose exec app ash

.PHONY: docker-update
docker-update:
	docker-compose exec app go install -ldflags "$(LDFLAGS)" $(go list ./... | grep -v vendor/)
	docker-compose restart app

.PHONY: releases
releases: $(PLATFORMS)

.PHONY: $(PLATFORMS)
$(PLATFORMS):
	GOOS=$(os) GOARCH=$(arch) go build -ldflags "$(LDFLAGS)" -o releases/$(COMMIT)/$(os)/clearance

.PHONY: seeds
seeds:
	docker-compose up -d db
	@sleep 5  # TODO: fix this race
	docker-compose exec db psql -U $(POSTGRES_USER) -d $(POSTGRES_NAME) -f ./data/setup.sql
