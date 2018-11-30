FROM lkwg82/h2o-http2-server

MAINTAINER Harald Acker <hello@2innovate.at>

# system dependencies
RUN apk --no-cache upgrade; apk --no-cache add curl wget libc6-compat libstdc++ bash git openssh-client

RUN wget https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated -O /bin/dehydrated && chmod u+x /bin/dehydrated

COPY dehydrated.conf /etc/dehydrated/config
COPY dehydrated.web /dehydrated/web.2innovate.at/config
COPY dehydrated.blog /dehydrated/blog.2innovate.at/config

COPY dehydrated.hook /etc/dehydrated/hook.sh
COPY dehydrated.domains /root/.caddy/dehydrated/domains.txt

COPY start_dehydrated /etc/periodic/daily/
COPY pull_github /etc/periodic/15min/
COPY startup.sh /root/

RUN chmod u+x /etc/periodic/daily/start_dehydrated /etc/periodic/15min/pull_github /root/startup.sh

ARG HUGO_VERSION=0.52
RUN curl -sSL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    | tar -C /usr/bin -xz hugo \
    && chmod +x /usr/bin/hugo

COPY h2o.conf /etc/h2o/
