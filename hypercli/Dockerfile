FROM alpine:latest
MAINTAINER Akhyar Amarullah "akhyrul@gmail.com"

# system dependencies
RUN apk update && apk upgrade; apk add git wget curl tar openssl ca-certificates \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/*

# workaround, because hyper-cli needs glibc that's not available on alpine by default
# https://github.com/sgerrand/alpine-pkg-glibc
ARG GLIBC_VERSION=2.23-r3
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q -O /tmp/glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && apk add --no-cache /tmp/glibc.apk && rm /tmp/glibc.apk

# install hyper
RUN wget -q -O /tmp/hyper.tar.gz https://hyper-install.s3.amazonaws.com/hyper-linux-x86_64.tar.gz \
    && tar -xzf /tmp/hyper.tar.gz -C /usr/bin && chmod +x /usr/bin/hyper \
    && rm /tmp/hyper.tar.gz

# install nodejs
RUN apk add --no-cache nodejs npm

# install typescript
RUN npm install -g typescript

# install libgit2
RUN apk add --no-cache libgit2

COPY 2i-web-rerun.sh /2i-web-rerun.sh

COPY github-monitor /github-monitor

# Install required modules and compile
RUN cd /github-monitor && npm install && npm run build

CMD hyper
