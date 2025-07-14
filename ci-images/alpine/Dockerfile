FROM python:3-alpine3.22

RUN apk add --no-cache git unzip groff build-base libffi-dev cmake

RUN apk add --no-cache aws-cli


# reduce image size: remove autocomplete and examples
RUN rm -rf \
    /usr/local/lib/aws-cli/aws_completer \
    /usr/local/lib/aws-cli/awscli/data/ac.index \
    /usr/local/lib/aws-cli/awscli/examples
RUN find /usr/local/lib/aws-cli/awscli/data -name completions-1*.json -delete
RUN find /usr/local/lib/aws-cli/awscli/botocore/data -name examples-1.json -delete
RUN (cd /usr/local/lib/aws-cli; for a in *.so*; do test -f /lib/$a && rm $a; done)

USER root

# Remove existing AWS CLI installation if present
RUN rm -rf /usr/local/aws-cli /usr/local/bin/aws

RUN apk add --update --no-cache jq wget py-pip curl bash git openssh-client
RUN ln -s /usr/local/lib/aws-cli/aws /usr/local/bin/aws
COPY bin /usr/local/bin
RUN install-rok8s-requirements
