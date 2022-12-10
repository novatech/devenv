FROM redhat/ubi9-minimal:latest

COPY ./scripts/ /tmp/scripts

ENV TERM=xterm-256color

RUN bash /tmp/scripts/bootstrap.sh

USER azwan

WORKDIR /home/azwan
