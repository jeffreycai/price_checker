# load and export .env
ifneq (,$(wildcard ./.env))
include .env
export
endif

## vars
EXECUTOR_IMAGE ?= jeffreycai/executor
BUILD_ID ?= $(shell date +%s)
COMPOSE_RUN_DOCKER=EXECUTOR_IMAGE=$(EXECUTOR_IMAGE) BUILD_ID=$(BUILD_ID) docker-compose run --rm executor



## local docker-compose stub jobs
# build app container image
build: dotenv
	@$(COMPOSE_RUN_DOCKER) make _build
.PHONY: build

deploy: dotenv
	@$(COMPOSE_RUN_DOCKER) make _deploy
.PHONY: deploy

# clean up all resources created in this demo
cleanup: dotenv
	@echo "Cleaning up docker containers,images,volumes,network"
	@EXECUTOR_IMAGE=$(EXECUTOR_IMAGE) BUILD_ID=$(BUILD_ID) docker-compose stop
	@EXECUTOR_IMAGE=$(EXECUTOR_IMAGE) BUILD_ID=$(BUILD_ID) docker-compose rm -f
	@docker image rm $(EXECUTOR_IMAGE)
	@docker image rm docker:18-dind
	@docker volume rm $(APP_NAME)_dind-certs-ca
	@docker volume rm $(APP_NAME)_dind-certs-client
	@docker network rm $(APP_NAME)_default

# into executor cli for debugging
cli: dotenv
	@$(COMPOSE_RUN_DOCKER) /bin/bash


## actual build jobs
_build: dotenv
	echo "IN"
.PHONY: build

_deploy: dotenv
	bash shell/deploy.sh
.PHONY: deploy




## Util jobs
# start a shell session for debug in container with Executor Image
shell: dotenv
	@$(COMPOSE_RUN_DOCKER) bash
.PHONY: shell


# replaces .env with DOTENV if the variable is specified
dotenv:
ifdef DOTENV
	cp -f $(DOTENV) .env
else
	$(MAKE) .env
endif
ifdef CI
	@mkdir -p ~/.docker
	@echo '${DOCKER_AUTH_CONFIG}' > ~/.docker/config.json
	env >> .env
endif


# creates .env with .env.template if it doesn't exist already, .env.template provide default env vars
.env:
	@if [ ! -f ".env" ]; then cp -f .env.template .env; fi
