FROM abiosoft/caddy:no-stats

MAINTAINER Harald Acker <hello@2innovate.at>

# system dependencies
RUN apk update;apk upgrade; apk add curl

# install hugo
ARG HUGO_VERSION=0.49.1
RUN curl -sSL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
    | tar -C /usr/bin -xz hugo \
    && chmod +x /usr/bin/hugo

COPY Caddyfile /etc/Caddyfile
