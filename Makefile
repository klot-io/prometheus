ACCOUNT=klotio
IMAGE=prometheus
VERSION?=0.2
NAME=$(IMAGE)-$(ACCOUNT)
NAMESPACE=prometheus
VOLUMES=-v ${PWD}/data:/prometheus
TILT_PORT=9090

.PHONY: cross build shell up down push install update remove reset tag untag

cross:
	docker run --rm --privileged multiarch/qemu-user-static:register --reset

build:
	docker build . -t $(ACCOUNT)/$(IMAGE):$(VERSION)

shell:
	docker run -it --rm --name=$(NAME) $(VOLUMES) $(ENVIRONMENT) $(ACCOUNT)/$(IMAGE):$(VERSION) sh

up:
	mkdir -p data
	echo "- op: replace\n  path: /spec/template/spec/volumes/0/hostPath/path\n  value: $(PWD)/data" > tilt/data.yaml
	kubectx docker-desktop
	-kubectl label node docker-desktop prometheus.klot.io/storage=enabled
	tilt --port $(TILT_PORT) up

down:
	kubectx docker-desktop
	tilt down

push:
	docker push $(ACCOUNT)/$(IMAGE):$(VERSION)

install:
	-kubectl create ns $(NAMESPACE)
	kubectl create -f kubernetes/gui.yaml

update:
	kubectl replace -f kubernetes/gui.yaml

remove:
	-kubectl delete -f kubernetes/gui.yaml
	-kubectl delete ns $(NAMESPACE)

reset: remove install

tag:
	-git tag -a "v$(VERSION)" -m "Version $(VERSION)"
	git push origin --tags

untag:
	-git tag -d "v$(VERSION)"
	git push origin ":refs/tags/v$(VERSION)"
