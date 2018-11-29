FROM abiosoft/caddy:no-stats

MAINTAINER Harald Acker <hello@2innovate.at>

# system dependencies
RUN apk --no-cache upgrade; apk --no-cache add curl wget libc6-compat libstdc++

ARG HUGO_VERSION=0.52
RUN curl -sSL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    | tar -C /usr/bin -xz hugo \
    && chmod +x /usr/bin/hugo

COPY Caddyfile /etc/Caddyfile
