FROM cimg/base:current-24.04

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y -qq jq wget python3-pip python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY bin /usr/local/bin
RUN install-rok8s-requirements
