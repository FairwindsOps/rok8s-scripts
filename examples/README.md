# Examples

This examples are to help give a basic overview of what a repository using `rok8-scripts` might look like.

## Circle-20

An example CircleCI 2.0 build and deploy via Helm chart with development, staging, and production configuration.

## Minimal

A small example of CircleCI building/deploying an app consisting of a Deployment and Service. It attempts to be the minimum needed to get a service working inside of Kubernetes but is missing features expected of a true production deployment.

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

## Optional-Components

An example where production uses a Horizontal Pod Autoscaler but staging does
not.

## sops-secrets

An example showing the decryption of a sops-encrypted file and deployment of the secret to Kubernetes.

The encrypted file can be created with a command similar to:

```
sops --encrypt --gcp-kms projects/example-project/locations/global/keyRings/example-keyring/cryptoKeys/example-key example.secret.yml
```
