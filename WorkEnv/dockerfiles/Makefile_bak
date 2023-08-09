SHELL:=/bin/bash
BUILDPATH=$(CURDIR)

# parameters
GIT_COMMIT:=$(shell git rev-parse --short HEAD)
#PROJECT_NAME=network-tools
PROJECT_NAME=system-tools
VERSION?=v1
MAINTAINER=yakirinp

# local image
LOCAL_IMAGE_NAME=${PROJECT_NAME}:${VERSION}
# hub.docker.com image
DOCKERHUB_IMAGE_NAME = ${MAINTAINER}/${PROJECT_NAME}:${VERSION}

# docker parameters
DOCKER_CMD=$(shell which docker)
PODMAN_CMD=$(shell which podman)
DOCKER_BUILD=$(DOCKER_CMD) build
DOCKER_PRUNE=$(DOCKER_CMD) image prune -f
DOCKER_RMI=$(DOCKER_CMD) rmi ${LOCAL_IMAGE_NAME} && $(DOCKER_CMD) rmi ${DOCKERHUB_IMAGE_NAME}
DOCKER_TAG=$(DOCKER_CMD) tag
DOCKER_PUSH=$(DOCKER_CMD) push

.PHONY: all build clean docker test

all: build docker clean

build:
	@echo "##### build step start #####"
	@echo "No need to build binary"
	@echo "##### build step end #####"

clean:
	@echo "##### clean step start #####"
	$(DOCKER_PRUNE)
	$(DOCKER_RMI)
	@echo "##### clean step end #####"

docker: docker-build docker-tag docker-push

.ONESHELL: docker-build docker-tag docker-push

docker-build:
	@echo "##### docker-build step start #####"
	$(DOCKER_BUILD) -t ${LOCAL_IMAGE_NAME} -f ${PROJECT_NAME}/Dockerfile .
	@echo "##### docker-build step end #####"

docker-tag:
	@echo "##### docker-tag step start #####"
	$(DOCKER_TAG) ${LOCAL_IMAGE_NAME} ${DOCKERHUB_IMAGE_NAME}
	@echo "##### docket-tag step end #####"

docker-push:
	@echo "##### docker-push step start #####"
	$(DOCKER_PUSH) ${DOCKERHUB_IMAGE_NAME}
	@echo "##### docker-push step end #####"

test:
	@echo ${LOCAL_IMAGE_NAME}
	@echo ${DOCKERHUB_IMAGE_NAME}
