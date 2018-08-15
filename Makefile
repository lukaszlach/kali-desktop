DOCKER_IMAGE_NAME ?= lukaszlach/kali-desktop
# gnome (creates new displays, does not work)
# kde (heaviest and slow in browser, too much effects)
# lxde
# xfce (most lightweight)
KALI_DESKTOPS := xfce lxde kde
KALI_DESKTOP ?= xfce

build: build-auto
	docker build --build-arg KALI_DESKTOP="${KALI_DESKTOP}" -t docker-kali .
	docker tag docker-kali ${DOCKER_IMAGE_NAME}:${KALI_DESKTOP}
	docker tag docker-kali ${DOCKER_IMAGE_NAME}:$$(docker run --entrypoint '' docker-kali bash -c '. /etc/os-release; echo "$$VERSION";')-${KALI_DESKTOP}
	${MAKE} list

build-auto:
	echo ${KALI_DESKTOPS} | xargs -n1 -I{} bash -c "sed 's/\(^ARG KALI_DESKTOP\)/\1={}/g' Dockerfile > Dockerfile.{}"

list:
	docker images | grep ${DOCKER_IMAGE_NAME}

push:
	docker images --format '{{.Repository}}:{{.Tag}}' | \
		grep '${DOCKER_IMAGE_NAME}' | \
		xargs -n1 docker push

run:
	docker rm -f docker-kali || true
	docker run -v $$(pwd)/etc/services.d:/etc/services.d:ro -v $$(pwd)/etc/cont-init.d:/etc/cont-init.d:ro -it --name docker-kali -p 5900:5900 -p 6080:6080 -e USER=kali -v $$(pwd)/home/kali:/home/kali --privileged docker-kali

run-prod:
	docker rm -f docker-kali || true
	docker run -it --name docker-kali --network host --privileged docker-kali

stop:
	docker kill docker-kali

cli:
	docker exec -it docker-kali bash

run-cli:
	docker run -it --entrypoint '' docker-kali bash