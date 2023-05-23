NAME = yakirinp/work_memo
VERSION = 1.0
DOCKER_REGISTRY = hub.docker.com/

.PHONY: clean build all
all: build docker-build clean

clean:
	@#rm *.o temp tmp
	@#docker image prune -f

build:
	@#echo no need to build

docker-build: docker-image docker-tag docker-push


.ONESHELL: docker-image docker-tag docker-push
docker-image:
	docker build -t ${NAME}:${VERSION} .

docker-tag:
	@#docker tag ${NAME}:${VERSION} ${DOCKER_REGISTRY}${PNAME}:${VERSION}

docker-push:
	docker push ${NAME}:${VERSION}
