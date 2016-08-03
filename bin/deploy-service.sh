#!/bin/bash

# MODIFIED by Ross Kukulinski <ross@kukulinski.com>
# Copyright 2016 Ross Kukulinski All rights reserved

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
# $2 = directory that contains your kubernetes files to deploy

DEPLOY_TIMEOUT=${DEPLOY_TIMEOUT:-300}
CONTEXT="$1"

#set config context
~/.kube/kubectl config use-context ${CONTEXT}

#get user password and api ip from config data
export kubepass=`(~/.kube/kubectl config view -o json | jq ' { mycontext: .["current-context"], contexts: .contexts[], users: .users[], clusters: .clusters[]}' | jq 'select(.mycontext == .contexts.name) | select(.contexts.context.user == .users.name) | select(.contexts.context.cluster == .clusters.name)' | jq .users.user.password | tr -d '\"')`

export kubeuser=`(~/.kube/kubectl config view -o json | jq ' { mycontext: .["current-context"], contexts: .contexts[], users: .users[], clusters: .clusters[]}' | jq 'select(.mycontext == .contexts.name) | select(.contexts.context.user == .users.name) | select(.contexts.context.cluster == .clusters.name)' | jq .users.user.username | tr -d '\"')`

export kubeurl=`(~/.kube/kubectl config view -o json | jq ' { mycontext: .["current-context"], contexts: .contexts[], users: .users[], clusters: .clusters[]}' | jq 'select(.mycontext == .contexts.name) | select(.contexts.context.user == .users.name) | select(.contexts.context.cluster == .clusters.name)' | jq .clusters.cluster.server | tr -d '\"')`

export kubenamespace=`(~/.kube/kubectl config view -o json | jq ' { mycontext: .["current-context"], contexts: .contexts[]}' | jq 'select(.mycontext == .contexts.name)' | jq .contexts.context.namespace | tr -d '\"')`

export kubeip=`(echo $kubeurl | sed 's~http[s]*://~~g')`

export https=`(echo $kubeurl | awk 'BEGIN { FS = ":" } ; { print $1 }')`

# Ensure service exists, create it if not
~/.kube/kubectl get service ${SERVICENAME} &>/dev/null
if [ $? -ne 0 ]
then
  echo "Service does not exist yet, creating it"
  ~/.kube/kubectl create -f kube/${SERVICENAME}.svc.yml
else
  echo "Service already exists, continuing"
fi
# Ensure deployment exists, create it if not
~/.kube/kubectl get deployment ${SERVICENAME} &>/dev/null
if [ $? -ne 0 ]
then
  echo "Deployment does not exist yet, creating it"
  ~/.kube/kubectl create -f kube/${SERVICENAME}.deployment.yml --record
else
  echo "Deployment already exists, continuing"
fi


# perform a rolling update by updating the Deployment
sed 's/:latest/':${CIRCLE_SHA1}'/g;' kube/${SERVICENAME}.deployment.yml > kube/${SERVICENAME}.deployment.${CIRCLE_SHA1}.yml
~/.kube/kubectl apply -f kube/${SERVICENAME}.deployment.${CIRCLE_SHA1}.yml

script/timeout.sh -t ${DEPLOY_TIMEOUT} script/verify-deployment.sh ${CONTEXT}
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
