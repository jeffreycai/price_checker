## Answers

[REQUIREMENT](/REQUIREMENT.md)

- [Github](https://github.com/jeffreycai/price_checker)
- [Dockerhub](https://hub.docker.com/repository/docker/bluestreamjc/price_checker)
- [Live App](http://13.238.89.106:8080/)

### Part 1

> Using the language of your choice, create a simple
> webservice that returns a json object containing spot price
> data from coinbase
> 
> [https://api.coinbase.com/v2/prices/spot?currency=USD](https://api.coinbase.com/v2/prices/spot?currency=USD) on
> requests to `/<currency>`.
> 
> The endpoint should minimally support: `EUR`, `GBP`, `USD` and `JPY`.
> This service should be run in a container. The container
> should be built via github actions.
> Include a `/health` endpoint that returns 200 if the
> application is running.

#### Answers

- Simple HTTP web server built using Python. [source code](/app)
- Endpoint `/<currency>` returns spot price and supports all coinbase currency code. See `/` homepage for full list.
- Service run on container and built via github actions or can be built locally.
- `/health` endpoint returns 200


#### Extra Answers

- Uses [3 Musketeers](https://3musketeers.io/) devops model, which has consistant results no matter where the CI / CD is run.
-  `400` handling for wrong currency code.
- [.credentials](/.credentials) file stores secrets and encrypted by Ansible Vault. Vault password is kept in Github secrets or local `.env` file (ignored by git)
- Container image managed in [Dockerhub](https://hub.docker.com/r/bluestreamjc/price_checker).

### Part 2

> Expand the Github Actions used to create the container to create some simple tests. The test should attempt to connect to the mock service and should fail if the json object cannot parsed, or if the currency does not exist.

#### Answers

- [Simple Test](https://github.com/jeffreycai/price_checker/blob/main/Makefile#L48)
- If the json object cannot be parsed, app will [return 500](https://github.com/jeffreycai/price_checker/blob/main/app/webserver.py#L66)
- If the currency does not exist, app will [return 400](https://github.com/jeffreycai/price_checker/blob/main/app/webserver.py#L49)
- [Github workflow](https://github.com/jeffreycai/price_checker/blob/main/.github/workflows/main.yml#L52)

### Optional extras

> - Include a `/metrics` or `/health` endpoint that reports simple health metrics
> - Integrate slack messaging into the github actions or directly into the application
> - Build a helm chart to deploy the service via github actions
> - Write terraform that can deploy the container into AWS (ECS, EKS, ec2, lambda)

#### Answers

- `http://<server>:8080/health` endpoint for Health Check
- `http://<server>:8000` endpoint for Metrics
- Slack integrated in [Github workflow](https://github.com/jeffreycai/price_checker/blob/main/.github/workflows/main.yml#L27). Secrets to be updated in Github secrets or local `.env` file
- Helm chart not yet done.
- Terraform not yet done.

## Appendex

### How to deploy locally

Uses [3 Musketeers](https://3musketeers.io/), so should run anywhere. But latest OSX seems to have issues with `docker-compose` running `dind`. Other Linux should be good. Tested on Amazon Linux 2 and Ubuntu

Clone the repo

```
git clone git@github.com:jeffreycai/price_checker.git
cd price_checker
```

Generate `.env` file

```
make dotenv
```

Update `.env` file with correct Vault Password

```
VAULT_PASSWORD=Interview_01!
```

Build and push to DockerHub

```
make build
```

Test

```
make test
```

Run webserver on localhost 8080 and 8000

```
make run # run the server
make stop # stop the server
```

When done, clean up
```
make cleanup
```

