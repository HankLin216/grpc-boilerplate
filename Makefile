VERSION=$(shell git describe --tags --always)
API_PROTO_FILES=$(shell find api -name "*.proto" -print0 | xargs -0 echo)
CONF_PROTO_FILES=$(shell find internal/conf -name "*.proto" -print0 | xargs -0 echo)
YMAL_CONF_PATH=./config.yaml

.PHONY: install
# install golang, protoc and related tools
install:
	sudo apt update && \
	sudo apt install -y protobuf-compiler && \
	sudo apt install -y golang && \
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

.PHONY: copy-config
# copy config
copy-config:
	mkdir -p ./bin
	cp ./configs/* ./bin/

.PHONY: api
# generate api proto
api:
	protoc --proto_path=api --proto_path=./third_party \
	--go_out=paths=source_relative:api \
	--go-grpc_out=paths=source_relative:api \
	$(API_PROTO_FILES)

.PHONY: config
# generate config proto
config:
	protoc --proto_path=internal --proto_path=./third_party \
	--go_out=paths=source_relative:internal \
	--go-grpc_out=paths=source_relative:internal \
	$(CONF_PROTO_FILES)

.PHONY: generate
# generate wire
generate:
	go generate ./...

.PHONY: build
# build production
build: copy-config
	go build -o ./bin/app -ldflags "-s -w -X main.Version=$(VERSION) -X main.Env=Production -X main.ConfFolderPath=$(YMAL_CONF_PATH)" ./cmd/server

.PHONY: dev-build
# build development
dev-build: copy-config
	go build -o ./bin/app -ldflags "-s -w -X main.Version=$(VERSION) -X main.Env=Development -X main.ConfFolderPath=$(YMAL_CONF_PATH)" ./cmd/server

.PHONY: all
# generate all
all: api config generate build

.PHONY: dev-all
# generate development all
dev-all: api config generate dev-build

.PHONY: build-image
# build production image
build-image:
	docker build --build-arg ENVIRONMENT=Production -t grpc-boilerplate:$(VERSION) -f Dockerfile .

.PHONY: dev-build-image
# build development image
dev-build-image:
	docker build --build-arg ENVIRONMENT=Development -t grpc-boilerplate:$(VERSION)-dev -f Dockerfile .

.PHONY: run-image
# run production image
run-image:
	docker run -d --rm --name grpc-boilerplate -p 9000:9000 grpc-boilerplate:$(VERSION)

.PHONY: dev-run-image
# run development image
dev-run-image:
	docker run -d --rm --name grpc-boilerplate-dev -p 9000:9000 grpc-boilerplate:$(VERSION)-dev

.PHONY: docker-compose
# run docker-compose
docker-compose: build-image
	VERSION=$(VERSION) docker-compose up -d

.PHONY: dev-docker-compose
# run development docker-compose
dev-docker-compose: dev-build-image
	VERSION=$(VERSION)-dev docker-compose up -d

.PHONY: help
# show help
help:
	@echo ''
	@echo 'Usage:'
	@echo ' make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
	helpMessage = match(lastLine, /^# (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
			printf "\033[36m%-22s\033[0m %s\n", helpCommand,helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help