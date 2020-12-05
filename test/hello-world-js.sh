#!/usr/bin/env bash

set -euo pipefail

confirm_output() {
  docker ps -aq | xargs docker kill
  docker run --rm -p 9000:8080 hello-world-js &
  sleep 3
  output=$(curl -s -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}')

  if [ "\"{\\\"message\\\": \\\"Hello World!\\\"}\"" != "${output}" ]; then
    echo "FAILED: ${output}"
    exit 1
  fi

  docker ps -aq | xargs docker kill
}

echo "=== TEST jkutner/aws-lambda-builder:18"
pack trust-builder jkutner/aws-lambda-builder:18
pack build --clear-cache \
  --builder jkutner/aws-lambda-builder:18 \
  --path fixtures/hello-world-js \
  --pull-policy=if-not-present \
  hello-world-js
confirm_output
echo "SUCCESS"

echo "=== TEST heroku/buildpacks:18"
docker pull heroku/buildpacks:18
pack build --clear-cache \
  --builder heroku/buildpacks:18 \
  --buildpack jkutner/aws-lambda-cnb \
  --path fixtures/hello-world-js \
  --pull-policy=if-not-present \
  hello-world-js
confirm_output
echo "SUCCESS"