FROM docker:20.10.7

USER root

RUN apk add --update --no-cache jq wget py-pip curl bash git openssh-client

COPY bin /usr/local/bin
RUN install-rok8s-requirements
