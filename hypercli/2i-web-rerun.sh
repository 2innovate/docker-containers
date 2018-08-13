#!/bin/sh

hyper config --default-region eu-central-1 --accesskey $HYPER_ACCESS --secretkey $HYPER_SECRET

IMAGE="2innovate/2i-web"
CONTAINER_NAME="2i-web"
VOLUME_NAME="2i-web-keys"
URL="https://2innovate.at/"

if [ "$(hyper volume ls -f image=$IMAGE -q)" == $VOLUME_NAME"-schwub" ]; then
    NEW_SUFFIX="blue"
    OLD_SUFFIX="schwub"
else
    NEW_SUFFIX="schwub"
    OLD_SUFFIX="blue"
fi

hyper pull $IMAGE

hyper snapshot create --name $VOLUME_NAME -v "$VOLUME_NAME"-"$OLD_SUFFIX" -f
hyper volume create --name "$VOLUME_NAME"-"$NEW_SUFFIX" --snapshot $VOLUME_NAME
hyper snapshot rm $VOLUME_NAME

hyper run -d -v "$VOLUME_NAME"-"$NEW_SUFFIX":/root/.caddy -p 80:80 -p 443:443 --size=s1 --restart always --noauto-volume -e ACME_AGREE=true --name "$CONTAINER_NAME"-"$NEW_SUFFIX" $IMAGE

sleep 60

hyper ps -a -f NAME="$CONTAINER_NAME"-"$NEW_SUFFIX" | grep Up

if [ $? -ne 0 ]; then
    sleep 600

    hyper ps -a -f NAME="$CONTAINER_NAME"-"$NEW_SUFFIX" | grep Up

    if [ $? -ne 0 ]; then
        echo "hyper run went wrong..."
        hyper stop "$CONTAINER_NAME"-"$NEW_SUFFIX"
        hyper rm --volume "$CONTAINER_NAME"-"$NEW_SUFFIX"
        hyper volume rm "$VOLUME_NAME"-"$OLD_SUFFIX"

        if [ "$(hyper images -f "dangling=true" -q)" != "" ]; then
            hyper rmi $(hyper images -f "dangling=true" -q)
        fi
    fi
fi

hyper fip detach "$CONTAINER_NAME"-"$OLD_SUFFIX"
hyper fip attach 169.197.100.129 "$CONTAINER_NAME"-"$NEW_SUFFIX"

sleep 5

if [ "curl -sw %{http_code} --output /dev/null $URL" != "200" ]; then
    echo "Caddy start went wrong..."
    hyper fip detach "$CONTAINER_NAME"-"$NEW_SUFFIX"
    hyper fip attach 169.197.100.129 "$CONTAINER_NAME"-"$OLD_SUFFIX"

    hyper stop "$CONTAINER_NAME"-"$NEW_SUFFIX"
    hyper rm --volume "$CONTAINER_NAME"-"$NEW_SUFFIX"
    hyper volume rm "$VOLUME_NAME"-"$OLD_SUFFIX"
else
    hyper stop "$CONTAINER_NAME"-"$OLD_SUFFIX"
    hyper rm --volumes "$CONTAINER_NAME"-"$OLD_SUFFIX"
    hyper volume rm "$VOLUME_NAME"-"$OLD_SUFFIX"
fi



if [ "$(hyper images -f "dangling=true" -q)" != "" ]; then
    hyper rmi $(hyper images -f "dangling=true" -q)
fi
