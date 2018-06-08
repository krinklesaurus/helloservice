SOURCEDIR = .
NAME ?= helloservice
VERSION=$(shell git rev-parse --short HEAD)

default: build

.PHONY: init
init:
	dep ensure


.PHONY: clean
clean:
	@if [ -f ${NAME} ] ; then rm ${NAME}; fi


.PHONY: test
test:
	go test -v -race -cover $$(go list ./... | grep -v /vendor/)


.PHONY: vet
vet:
	go vet -v $(go list ./... | grep -v /vendor/)


.PHONY: lint
lint:
	golint $$(go list ./... | grep -v /vendor/)


.PHONY: build
build: clean test lint
	go build -a -installsuffix cgo -o ${NAME} ./cmd


.PHONY: run
run: 
	./${NAME}
	

.PHONY: dockerbuild
dockerbuild: clean test lint
	docker build -t ${NAME}:latest -t ${NAME}:${VERSION} .


.PHONY: dockerrun
dockerrun:
	docker run -p 8080:8080 ${NAME}:${VERSION}
