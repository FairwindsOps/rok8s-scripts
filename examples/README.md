# Examples

This examples are to help give a basic overview of what a repository using `rok8-scripts` might look like.


## Minimal

A small example of CircleCI building/deploying an app consisting of a Deployment and Service. It attempts to be the minimum needed to get a service working inside of Kubernetes but is missing features expected of a true production deployment.

## Production-Ready

An example including:

* Staging and Production environments
* DB migrations with BlockingJob
* Internal ELB for staging
* Horizontal Pod Autoscaler for setting number of replicas
* Usage `namespace` metadata to ensure application to the correct Kube namespace

Deployment Features:
* `revisionHistoryLimit` to remove old ReplicaSets
* Volume mounting of Secrets and ConfigMap
* Resource requests and limits
* Liveness Probe
