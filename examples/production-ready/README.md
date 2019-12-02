## Production-Ready

An example including:

* Staging and Production environments
* DB migrations with BlockingJob
* Internal ELB for staging
* Horizontal Pod Autoscaler for setting number of replicas
* Usage `namespace` metadata to ensure application to the correct Kube namespace
* Linting of your config and deploy files

Deployment Features:
* `revisionHistoryLimit` to remove old ReplicaSets
* Volume mounting of Secrets and ConfigMap
* Resource requests and limits
* Liveness Probe
