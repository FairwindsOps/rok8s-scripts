#!/bin/bash

cd examples
cp -r helm deploy
CI_SHA1=test helm-template -f deploy/production.config > helm-output.yaml
cmp helm-output.yaml ../test/files/helm-template-output.yaml
CMP_EXIT_CODE=$?
rm -rf deploy helm-output.yaml
exit $CMP_EXIT_CODE