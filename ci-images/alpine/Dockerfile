FROM python:3.11-alpine3.20 as builder

ARG AWS_CLI_VERSION=2.17.5
RUN apk add --no-cache git unzip groff build-base libffi-dev cmake
RUN git clone --single-branch --depth 1 -b ${AWS_CLI_VERSION} https://github.com/aws/aws-cli.git

WORKDIR aws-cli
RUN ./configure --with-install-type=portable-exe --with-download-deps
RUN make
RUN make install

# reduce image size: remove autocomplete and examples
RUN rm -rf \
    /usr/local/lib/aws-cli/aws_completer \
    /usr/local/lib/aws-cli/awscli/data/ac.index \
    /usr/local/lib/aws-cli/awscli/examples
RUN find /usr/local/lib/aws-cli/awscli/data -name completions-1*.json -delete
RUN find /usr/local/lib/aws-cli/awscli/botocore/data -name examples-1.json -delete
RUN (cd /usr/local/lib/aws-cli; for a in *.so*; do test -f /lib/$a && rm $a; done)


FROM docker:27.0.2

USER root

RUN apk add --update --no-cache jq wget py-pip curl bash git openssh-client
RUN ln -s /usr/local/lib/aws-cli/aws /usr/local/bin/aws
COPY --from=builder /usr/local/lib/aws-cli/ /usr/local/lib/aws-cli/
COPY bin /usr/local/bin
RUN install-rok8s-requirements
