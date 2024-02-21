VER=1.11
container=mjethanandani/build-yang

.PHONY: container push all clean

leftover=$(shell docker ps -a -q -f status=exited)
leftover-image=$(shell docker images -a -q)

all: container

container:
	docker build -t $(container):$(VER) .

push:
	docker push $(container):$(VER)
	docker push $(container):latest
	docker tag $(container):$(VER) $(container):latest

clean:
	-docker rm $(leftover)
	-docker rmi $(leftover-image)

debug:
	docker run -it $(container):$(VER) bash
