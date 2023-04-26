FROM docker:20.10.7

USER root

RUN apk add --update --no-cache jq wget py-pip curl bash git openssh-client binutils

RUN export GLIBC_VERSION=2.35-r0

RUN curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub
RUN curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk
RUN curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk
RUN curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk
RUN apk add --no-cache --force-overwrite \
        glibc-${GLIBC_VERSION}.apk \
        glibc-bin-${GLIBC_VERSION}.apk \
        glibc-i18n-${GLIBC_VERSION}.apk
RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
RUN ln -sf /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
RUN rm -rf glibc-*.apk
RUN rm -rf /var/cache/apk/*

COPY bin /usr/local/bin
RUN install-rok8s-requirements
