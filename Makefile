# load and export .env and .credentials_decrypted
ifneq (,$(wildcard ./.env))
include .env
export
endif

ifneq (,$(wildcard ./.credentials_decrypted))
include .credentials_decrypted
export
endif

## vars
EXECUTOR_IMAGE ?= jeffreycai/musketeers
BUILD_ID ?= $(shell date +%s)
COMPOSE_RUN_DOCKER=EXECUTOR_IMAGE=$(EXECUTOR_IMAGE) BUILD_ID=$(BUILD_ID) docker-compose run --rm executor



## local docker-compose stub jobs
# build app container image
build: dotenv dotcreds
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
_build:
	docker build -t $(APP_NAME):$(BUILD_ID) .
	@docker login --username $(DOCKERHUB_USERNAME) -p $(DOCKERHUB_ACCESS_TOKEN)
	docker tag $(APP_NAME):$(BUILD_ID) $(DOCKERHUB_USERNAME)/$(APP_NAME):$(BUILD_ID)
	docker push $(DOCKERHUB_USERNAME)/$(APP_NAME):$(BUILD_ID)
.PHONY: build

_deploy:
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

# decrypt .credentials to .credentials_decrypted
dotcreds:
	@echo $(VAULT_PASSWORD) > .vault_password
	@cp .credentials .credentials_decrypted
	@$(COMPOSE_RUN_DOCKER) ansible-vault decrypt .credentials_decrypted --vault-password-file .vault_password

# creates .env with .env.template if it doesn't exist already, .env.template provide default env vars
.env:
	@if [ ! -f ".env" ]; then cp -f .env.template .env; fi
