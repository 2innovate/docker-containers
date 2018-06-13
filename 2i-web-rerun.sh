#!/bin/sh

hyper config --default-region eu-central-1 --accesskey $HYPER_ACCESS --secretkey $HYPER_SECRET
hyper pull 2innovate/2i-web

