image: build

env:
	$(eval GIT_REF=$(shell git rev-parse --short HEAD))
	$(eval CPUS=$(shell cat cpus.txt))

build: env
	@echo building verusccminer:${GIT_REF}
	@docker build -f Dockerfile -t verusccminer:${GIT_REF} .

daemon: build
	@docker run --cpus=${CPUS} verusccminer:${GIT_REF}

miner: daemon
