FROM lkwg82/h2o-http2-server

MAINTAINER Harald Acker <hello@2innovate.at>

# system dependencies
RUN apk --no-cache upgrade; apk --no-cache add curl wget libc6-compat libstdc++

RUN wget https://github.com/lukas2511/dehydrated/blob/master/dehydrated -O /usr/local/bin/dehydrated && chmod u+x /usr/local/bin/dehydrated && mkdir /etc/dehydrated && chown root:root /etc/dehydrated

COPY dehydrated.conf /etc/dehydrated/config
COPY dehydrated.hook /etc/dehydrated/hook.sh
COPY dehydrated.domains /etc/dehydrated/domains.txt


ARG HUGO_VERSION=0.51
RUN curl -sSL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    | tar -C /usr/bin -xz hugo \
    && chmod +x /usr/bin/hugo

COPY h2o.conf /etc/h2o/
