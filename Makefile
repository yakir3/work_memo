IMAGE_NAME = work_memo
VERSION = v1

PUSH_NAME = yakirinp/$(IMAGE_NAME)
DOCKER_REGISTRY = hub.docker.com/
GIT_COMMIT:=$(shell git rev-parse --short HEAD)
PUSH_FULL_NAME = ${DOCKER_REGISTRY}${PUSH_NAME}:${VERSION}

.PHONY: test clean build all
all: build docker-image clean

test:
	echo ${PUSH_FULL_NAME}

clean:
	@#rm *.o temp tmp
	@#docker image prune -f

build:
	@echo no need to build

docker-image: docker-build docker-tag docker-push

.ONESHELL: docker-build docker-tag docker-push
docker-build:
	@docker build -t ${IMAGE_NAME}:${VERSION} -f APP-META/Dockerfile .
	@#docker build -t ${IMAGE_NAME}-${GIT_COMMIT}:${VERSION} -f APP-META/Dockerfile .

docker-tag:
	@#podman tag ${IMAGE_NAME}:${VERSION} ${PUSH_FULL_NAME}
	@docker tag ${IMAGE_NAME}:${VERSION} ${PUSH_FULL_NAME}

docker-push:
	@docker push ${PUSH_FULL_NAME}
