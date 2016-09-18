#!/bin/bash

# Copyright 2014 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# $1 = the kubernetes context (specified in kubeconfig)
# $2 = if == 'rolling', perform a rolling update

# Uses environment variables:
# BUILD the docker image tag to be deployed.

set -euo pipefail

DEPLOY_TIMEOUT=${DEPLOY_TIMEOUT:-300}
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
CONTEXT="$1"

. $DIR/k8s-read-config



kubectl version

#get user, password, certs, namespace and api ip from config data
export kubepass=`(kubectl config view -o json --raw --minify  | jq .users[0].user.password | tr -d '\"')`

export kubeuser=`(kubectl config view -o json --raw --minify  | jq .users[0].user.username | tr -d '\"')`

export kubeurl=`(kubectl config view -o json --raw --minify  | jq .clusters[0].cluster.server | tr -d '\"')`

export kubenamespace=`(kubectl config view -o json --raw --minify  | jq .contexts[0].context.namespace | tr -d '\"')`

export kubeip=`(echo $kubeurl | sed 's~http[s]*://~~g')`

export https=`(echo $kubeurl | awk 'BEGIN { FS = ":" } ; { print $1 }')`

export certdata=`(kubectl config view -o json --raw --minify  | jq '.users[0].user["client-certificate-data"]' | tr -d '\"')`

export certcmd=""

export CONTEXT=$(kubectl config current-context)
if [ "$certdata" != "null" ] && [ "$certdata" != "" ];
then
    kubectl config view -o json --raw --minify  | jq '.users[0].user["client-certificate-data"]' | tr -d '\"' | base64 --decode > ${CONTEXT}-cert.pem
    export certcmd="$certcmd --cert ${CONTEXT}-cert.pem"
fi

export keydata=`(kubectl config view -o json --raw --minify  | jq '.users[0].user["client-key-data"]' | tr -d '\"')`

if [ "$keydata" != "null" ] && [ "$keydata" != "" ];
then
   kubectl config view -o json --raw --minify  | jq '.users[0].user["client-key-data"]' | tr -d '\"' | base64 --decode > ${CONTEXT}-key.pem
    export certcmd="$certcmd --key ${CONTEXT}-key.pem"
fi

export cadata=`(kubectl config view -o json --raw --minify  | jq '.clusters[0].cluster["certificate-authority-data"]' | tr -d '\"')`

if [ "$cadata" != "null" ] && [ "$cadata" != "" ];
then
    kubectl config view -o json --raw --minify  | jq '.clusters[0].cluster["certificate-authority-data"]' | tr -d '\"' | base64 --decode > ${CONTEXT}-ca.pem
    export certcmd="$certcmd --cacert ${CONTEXT}-ca.pem"
fi

#print some useful data for folks to check on their service later

# Ensure configmaps are applied
echo "Ensure ConfigMaps"
for i in "${CONFIGMAP_FILES[@]}"
do
    echo "applying $i"
    kubectl apply -f ${i}
done

echo "Deploying Services"
for i in "${SERVICE_FILES[@]}"
do
  echo "applying $i"
  kubectl apply -f ${i}
done

if [ -z ${BUILD} ]; then
    echo "error, \$BUILD not set";
    exit 1;
fi

echo "Deploying Services"
for i in "${DEPLOYMENT_FILES[@]}"
do
    echo  "DOCKER_REPO: ${DOCKER_REPO}"
    echo  "DEPLOY_TAG: ${DEPLOY_TAG}"
    echo  "BUILD: ${BUILD}"
    echo "file: ${i}"
  sed -e "s|${DOCKER_REPO}:${DEPLOY_TAG}|${DOCKER_REPO}:${BUILD}|g;" ${i} > ${i}.${BUILD}
  kubectl apply -f ${i}.${BUILD}
done

for i in "${SERVICES}"
do
    echo "verify timeout $i"
    $DIR/timeout.sh -t ${DEPLOY_TIMEOUT} $DIR/verify-deployment.sh ${i}
done

result=$?
if [ "$result" == "143" ] ; then
    echo "------- DEPLOYMENT TIMEOUT FAIL --------"
    exit 1
fi
if [ "$result" == "0" ] ; then
  echo "DEPLOY SUCCESFULL"
  exit 0
fi
echo "DEPLOY FAILED"
exit $result
