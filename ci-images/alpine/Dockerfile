FROM docker:18

USER root

RUN apk add --update --no-cache jq wget py-pip curl bash git openssh-client \
    && pip install --no-cache-dir --disable-pip-version-check docker-compose

COPY bin /usr/local/bin
RUN install-rok8s-requirements
