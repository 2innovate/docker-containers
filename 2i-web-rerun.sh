#!/bin/sh

hyper config --default-region eu-central-1 --accesskey $HYPER_ACCESS --secretkey $HYPER_SECRET
hyper pull 2innovate/2i-web
hyper stop 2i-web
hyper rm --volumes 2i-web
hyper run -d -v 2i-web-keys:/root/.caddy -p 80:80 -p 443:443 --size=s1 --restart always --noauto-volume -e ACME_AGREE=true --name 2i-web 2innovate/2i-web
hyper fip attach 169.197.100.129 2i-web
hyper rmi $(hyper images -f "dangling=true" -q)
