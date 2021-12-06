FROM redhat/ubi8-minimal:latest

COPY ./scripts/ /tmp/scripts

ENV TERM=xterm-256color

RUN sh /tmp/scripts/bootstrap.sh

USER azwan

WORKDIR /home/azwan
