FROM circleci/buildpack-deps:stretch

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y -qq jq wget python-pip python-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY bin /usr/local/bin
RUN install-rok8s-requirements
