#!/bin/bash
set -eu

aliases='0 0.4 latest'
tag='mattrobenolt/twemproxy'

fullVersion=$(awk '$1 == "ENV" && $2 == "TWEMPROXY_VERSION" { print $3; exit }' Dockerfile)

docker build --pull --rm -t $tag:$fullVersion .
docker push $tag:$fullVersion

for alias in $aliases; do
    docker tag $tag:$fullVersion $tag:$alias
    docker push $tag:$alias
done
