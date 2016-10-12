#!/bin/bash

if ! hash aws 2>/dev/null; then
  pip install awscli
fi

$(aws ecr get-login)
# this should exit 0 even if the image is not there. For example, on a first run
docker pull ${EXTERNAL_REGISTRY_BASE_DOMAIN}/${REPOSITORY_NAME}:latest || true
