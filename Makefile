NAMESPACE := tobinquadros
IMAGE_NAME := clearance
IMAGE_TAG ?= latest

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
	go test -cover $$(go list ./... | grep -v vendor/)

.PHONY: benchmark
benchmark:
	go test -bench=. $$(go list ./... | grep -v vendor/ | grep -v cmd/)

.PHONY: compose
compose: db app

.PHONY: build
build: $(PLATFORMS)

.PHONY: $(PLATFORMS)
$(PLATFORMS):
	GOOS=$(os) GOARCH=$(arch) go build -ldflags "$(LDFLAGS)" -o build/$(os)/clearance

.PHONY: app
app: build
	docker-compose restart app 2&>/dev/null || docker-compose up -d app

.PHONY: db
db:
	docker-compose up -d db
	@sleep 5  # TODO: fix this race
	docker-compose exec db psql -U $(POSTGRES_USER) -d $(POSTGRES_NAME) -f ./data/setup.sql

.PHONY: db-shell
db-shell:
	docker-compose up -d db
	@sleep 5  # TODO: fix this race
	docker-compose exec db psql -U $(POSTGRES_USER)

.PHONY: clean
clean:
	docker-compose down --volumes --rmi local
	rm -rf ./build/

