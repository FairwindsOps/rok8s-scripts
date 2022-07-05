#!/bin/bash

cd bin || exit 1

# This script comes from gcloud, we don't control it.
rm docker-credential-gcloud

# Run shellcheck
shellcheck -x \
  docker-* \
  install-rok8s-requirements \
  k8s-apply \
  verify-deployment \
  k8s-lint \
  prepare-* \
  helm-*
