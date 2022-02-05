FROM python:slim-bullseye

RUN mkdir -p /opt/app
COPY . /opt/app
WORKDIR /opt/app/app

EXPOSE 8080

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/python main.py"]