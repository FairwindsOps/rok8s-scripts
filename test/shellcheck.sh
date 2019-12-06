#!/bin/bash

cd bin || exit 1

shellcheck -x docker-* \
  install-rok8s-requirements \
  k8s-apply \
  verify-deployment \
  k8s-lint \
  prepare-* \
  helm-*
