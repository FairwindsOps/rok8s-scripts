FROM python:3-alpine3.22

RUN apk add --no-cache aws-cli

# reduce image size: remove autocomplete and examples
RUN rm -rf \
    /usr/local/lib/aws-cli/aws_completer \
    /usr/local/lib/aws-cli/awscli/data/ac.index \
    /usr/local/lib/aws-cli/awscli/examples

USER root

RUN apk add --update --no-cache jq wget py-pip curl bash git openssh-client
COPY bin /usr/local/bin
RUN install-rok8s-requirements
