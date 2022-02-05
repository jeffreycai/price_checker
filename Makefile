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
build: dotenv
	@$(COMPOSE_RUN_DOCKER) make _build
.PHONY: build

deploy: dotenv
	@$(COMPOSE_RUN_DOCKER) make _deploy
.PHONY: deploy

cleanup: dotenv
	@EXECUTOR_IMAGE=$(EXECUTOR_IMAGE) BUILD_ID=$(BUILD_ID) docker-compose stop
	@EXECUTOR_IMAGE=$(EXECUTOR_IMAGE) BUILD_ID=$(BUILD_ID) docker-compose rm



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
