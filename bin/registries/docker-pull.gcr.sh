#!/bin/bash -e
echo "Preping to pull image from GCR."

if [ -z "$GCP_PROJECT" || -z "$GCP_CLUSTER" || -z "$GCP_ZONE" ]; then
  echo "Missing GCP project, cluster, or zone!  Aborting"
  exit 1
fi

if ! hash pyopenssl 2>/dev/null; then
  pip install pyopenssl
fi

if ! hash gcloud 2>/dev/null; then
  sudo apit-get install google-cloud-sdk
fi
# This could be moved in large part to the "pre" step, but not entirely.
# Leaving it here gives us the flexibility to do cluster/project based on branch.
KEYFILE=${HOME}/gcloud-service-key.json
export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/gcloud-service-key.json"
echo $GCLOUD_KEY | base64 --decode > "${KEYFILE}"
gcloud auth activate-service-account --key-file "${KEYFILE}" --project "${GCP_PROJECT}"

gcloud config set project "${GCP_PROJECT}"
gcloud config set container/cluster "${GCP_CLUSTER}"
gcloud config set compute/zone "${GCP_ZONE}"

gcloud container clusters get-credentials "${GCP_CLUSTER}"
#gcloud auth application-default login

# Authorize the docker client to work with GCR
gcloud docker --authorize-only
