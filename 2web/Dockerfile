FROM abiosoft/caddy:no-stats

MAINTAINER Harald Acker <hello@2innovate.at>

# system dependencies
RUN apk update;apk upgrade; apk add curl wget libstdc++

# workaround, because hugo needs glibc that's not available on alpine by default
# https://github.com/sgerrand/alpine-pkg-glibc
ARG GLIBC_VERSION=2.28-r0
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q -O /tmp/glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && apk add --no-cache /tmp/glibc.apk && rm /tmp/glibc.apk

# install hugo
ARG HUGO_VERSION=0.49.2
RUN curl -sSL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    | tar -C /usr/bin -xz hugo \
    && chmod +x /usr/bin/hugo

COPY Caddyfile /etc/Caddyfile
