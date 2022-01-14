SOURCEDIR = .
NAME ?= helloservice
VERSION=$(shell git rev-parse --short HEAD)

default: clean build

.PHONY: clean
clean:
	@rm -rf ${NAME}

.PHONY: test
test:
	golint $$(go list ./... | grep -v /vendor/) &&\
		go test -v -race -cover $$(go list ./... | grep -v /vendor/)

.PHONY: run
run:
	go run main.go

.PHONY: build
build:
	docker build -t ${NAME}:latest -t ${NAME}:${VERSION} -t krinklesaurus/${NAME}:${VERSION} -t krinklesaurus/${NAME}:latest .

.PHONY: push
push:
	docker push krinklesaurus/helloservice:latest &&\
		docker push krinklesaurus/helloservice:${VERSION}