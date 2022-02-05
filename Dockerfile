FROM python:slim-bullseye

RUN mkdir -p /opt/app
COPY . /opt/app
WORKDIR /opt/app/app

ENTRYPOINT ['/usr/local/bin/python', 'main.py']