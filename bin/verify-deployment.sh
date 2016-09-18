#!/usr/bin/env bash

set -euo pipefail

# $1 = the name of the service to verify

if [ -z $1 ];
then
    echo "service name must be specified";
    exit 1;
fi

SERVICENAME=$1

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get user password and api ip from config data
export kubepass=`(kubectl config view -o json | jq ' { mycontext: .["current-context"], contexts: .contexts[], users: .users[], clusters: .clusters[]}' | jq 'select(.mycontext == .contexts.name) | select(.contexts.context.user == .users.name) | select(.contexts.context.cluster == .clusters.name)' | jq .users.user.password | tr -d '\"')`

export kubeuser=`(kubectl config view -o json | jq ' { mycontext: .["current-context"], contexts: .contexts[], users: .users[], clusters: .clusters[]}' | jq 'select(.mycontext == .contexts.name) | select(.contexts.context.user == .users.name) | select(.contexts.context.cluster == .clusters.name)' | jq .users.user.username | tr -d '\"')`

export kubeurl=`(kubectl config view -o json | jq ' { mycontext: .["current-context"], contexts: .contexts[], users: .users[], clusters: .clusters[]}' | jq 'select(.mycontext == .contexts.name) | select(.contexts.context.user == .users.name) | select(.contexts.context.cluster == .clusters.name)' | jq .clusters.cluster.server | tr -d '\"')`

export kubenamespace=`(kubectl config view -o json | jq ' { mycontext: .["current-context"], contexts: .contexts[]}' | jq 'select(.mycontext == .contexts.name)' | jq .contexts.context.namespace | tr -d '\"')`

export kubeip=`(echo $kubeurl | sed 's~http[s]*://~~g')`

export https=`(echo $kubeurl | awk 'BEGIN { FS = ":" } ; { print $1 }')`

echo "Verify Deployment"

echo "context: $(kubectl config current-context)"
echo "servicename: ${SERVICENAME}"

echo "Checking deployment generation"
echo "Checking deployment generation"
OBS_GEN=-1
CURRENT_GEN=0
until [ $OBS_GEN -ge $CURRENT_GEN ]; do
  sleep 1
  CURRENT_GEN=$(kubectl get deployment ${SERVICENAME} -o json | jq .status.observedGeneration)
  OBS_GEN=$(kubectl get deployment ${SERVICENAME} -o json | jq .status.observedGeneration)
  echo "observedGeneration ($OBS_GEN) should be >= generation ($CURRENT_GEN)."
done
echo "observedGeneration ($OBS_GEN) is >= generation ($CURRENT_GEN)"

echo "Checking for updatedReplicas to equal replicas"
UPDATED_REPLIACS=-1
REPLICAS=0
until [ "$UPDATED_REPLIACS" == "$REPLICAS" ]; do
  sleep 1
  REPLICAS=$(kubectl get deployment ${SERVICENAME} -o json | jq .status.replicas)
  UPDATED_REPLIACS=$(kubectl get deployment ${SERVICENAME} -o json | jq .status.updatedReplicas)
  echo "updatedReplicas ($UPDATED_REPLIACS) should be == replicas ($REPLICAS)."
done
echo "updatedReplicas ($UPDATED_REPLIACS) is == replicas ($REPLICAS)."


echo "Checking for availableReplicas to equal replicas"
echo "SERVICENAME: ${SERVICENAME}"
AVAILABLE_REPLICAS=-1
REPLICAS=0
until [ "$AVAILABLE_REPLICAS" == "$REPLICAS" ]; do
  sleep 1
  REPLICAS=$(kubectl get deployment ${SERVICENAME} -o json | jq .status.replicas)
  AVAILABLE_REPLICAS=$(kubectl get deployment ${SERVICENAME} -o json | jq .status.availableReplicas)
  echo "availableReplicas ($AVAILABLE_REPLICAS) should be == replicas ($REPLICAS)."
done
echo "availableReplicas ($AVAILABLE_REPLICAS) is == replicas ($REPLICAS)."

echo "Deployment of $1 was successful"
echo ""
