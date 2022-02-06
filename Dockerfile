FROM python:slim-bullseye

RUN pip3 install prometheus-client
RUN mkdir -p /opt/app
COPY . /opt/app
WORKDIR /opt/app/app

EXPOSE 8080
EXPOSE 8000

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/python main.py"]