#!/bin/bash

cd bin

shellcheck -x docker-* \
  install-rok8s-requirements \
  k8s-apply \
  verify-deployment \
  k8s-lint \
  prepare-* \
  helm-*
