#!/bin/bash

# Runs a Kubernetes Job once. Designed for a single, non-parallel job, typically db migrations
# http://kubernetes.io/docs/user-guide/jobs/#parallel-jobs
# The job needs to be located in KUBERNETES_CONFIG_PATH, named ${JOB_NAME}.job.yml,
# and JOB_NAME should match the job's metadata.name attribute
# Usage: ./script/run-migrations.sh JOB_NAME

JOB_NAME="$1"
KUBERNETES_CONFIG_PATH=${KUBERNETES_CONFIG_PATH:-kube}
POLL_TRIES=${POLL_TRIES:-30}
POLL_WAIT=${POLL_WAIT:-10}

kubectl apply -f ${KUBERNETES_CONFIG_PATH}/${JOB_NAME}.job.yml

ACTIVE=$(kubectl get job -o json $JOB_NAME |jq .status.active)
if [ "$ACTIVE" != 1 ]
then
  echo "job hasn't started, something is wrong"
fi

COUNTER=0
while [  $COUNTER -lt $POLL_TRIES ]; do
  let COUNTER=COUNTER+1
  echo $JOB_NAME Job Check: $COUNTER
  ACTIVE=$(kubectl get job -o json $JOB_NAME |jq .status.active)
  SUCCEEDED=$(kubectl get job -o json $JOB_NAME |jq .status.succeeded)
  # echo Job Active: $ACTIVE
  # echo Job Succeeded: $SUCCEEDED
  if [ "$ACTIVE" == "null" ] && [ "$SUCCEEDED" == "1" ]; then
    echo "$JOB_NAME Job succesfully completed, deleting"
    kubectl delete job $JOB_NAME
    exit $?
  else
    sleep $POLL_WAIT
  fi
done

echo "JOB FAILED TO COMPLETE"
