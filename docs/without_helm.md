# Deploying to Kubernetes without Helm
Although [Helm](helm.md) is our preferred method of deploying to Kubernetes, rok8s-scripts also supports deploying to Kubernetes without Helm.

## Initial Project Structure
All rok8s-scripts configuration lives in a `deploy` directory at the root of your project by default. In this example, we have a simple Python app with a Dockerfile in place.

```plaintext
app-dir/
├── deploy/
│   ├── app.deployment.yml                     // k8s deployment used in all environments
│   ├── app-migrate.blocking_job.yml           // k8s blocking job used in all environments
│   ├── build.config                           // rok8s-scripts build config
│   ├── development/                           // contains files to deploy to dev
│   │   ├── app-env.secret.sops.yml            // sops encrypted secret for dev
│   │   └── app-env.configmap.yml              // config map specific to dev
│   │   └── app.horizontal_pod_autoscaler.yml  // HPA specific to dev
│   └── development.config                     // rok8s-scripts dev config
│   ├── staging/                               // contains files to deploy to staging
│   │   ├── app-env.secret.sops.yml            // sops encrypted secret for staging
│   │   └── app-env.configmap.yml              // config map specific to staging
│   │   └── app.horizontal_pod_autoscaler.yml  // HPA specific to staging
│   └── staging.config                         // rok8s-scripts staging config
├── app.py
├── Dockerfile
├── README.md
└── requirements.txt
```

Each Kubernetes resource config lives in the `deploy` directory of this repo, with filenames matching the desired rok8s-scripts format (see below for a full list). In this example, each environment has unique configuration in the form of a secret, config map, and HPA. Beyond those resources, each environment would share the deployment and migration configuration.

In the example above, the `development.config` rok8s-scripts configuration file would look something like:

```bash
CONFIGMAPS=("development/app-env")
SOPS_SECRETS=("development/app-env")
BLOCKING_JOBS=("app-migrate")
DEPLOYMENTS=("app")
HORIZONTAL_POD_AUTOSCALERS=("development/app")
```

This full configuration could be deployed with the following rok8s-scripts command:

```bash
k8s-deploy-and-verify -f deploy/development.config
```

More indepth examples are available in the [examples directory](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples).

## Credentials
See [Kubernetes auth](kubernetes_auth.md) to learn how to grant your CI pipeline access to your Kubernetes cluster

## Versioning
**If a Docker image is used in the file then any cases of `:latest` will be replaced with th `CI_SHA1` if it is defined.** This allows a set image tag to be used when deploying from a CI system. When files that could use `CI_SHA1` are deployed, a new file will be created with that value as part of the filename.

If using an HPA, set `replicas: hpa` in the deployment file to have k8s-deploy get the current number of replicas from the cluster and deploy that number of replicas. This is a workaround for an open issue (https://github.com/kubernetes/kubernetes/issues/25238).

## Deployment Configuration
Listed below are all the types of resources rok8s-scripts supports. In all cases, the filename suffix is important and must match the spec precisely.

```bash
# Cluster Namespace to work in
NAMESPACE='default'

# List of files ending in '.configmap.yml' in the kube directory
CONFIGMAPS=()

# List of files ending in '.configmap.fromfile' in the kube directory
FROMFILE_CONFIGMAPS=()

# List of files ending in '.service_account.yml' in the kube directory
SERVICE_ACCOUNTS=()

# List of files ending in '.secret.yml' in the kube directory
SECRETS=('example-app')

# List of files ending in '.secret.sops.yml' in the kube directory
SOPS_SECRETS=('example-app')

# List of files ending in '.external' in the kube directory
EXTERNAL_SECRETS=()

# List of files ending in '.persistent_volume.yml' in the kube directory
PERSISTENT_VOLUMES=('example-app')

# List of files ending in '.persistent_volume_claim.yml' in the kube directory
PERSISTENT_VOLUME_CLAIMS=('example-app')

# List of files ending in '.statefulset.yml' in the kube directory
STATEFULSETS=('example-app')

# List of files ending in '.service.yml' in the kube directory
SERVICES=('example-app')

# List of files ending in '.endpoint.yml' in the kube directory
ENDPOINTS=()

# List of files ending in '.ingress.yml' in the kube directory
INGRESSES=()

# List of files ending in '.deployment.yml' in the kube directory
DEPLOYMENTS=('example-app')

# List of files ending in '.horizontal_pod_autoscaler.yml' in the kube directory
HORIZONTAL_POD_AUTOSCALERS=()

# List of files ending in '.pod_disruption_budget.yml' in the kube directory
POD_DISRUPTION_BUDGETS=()

# List of files ending in '.job.yml' in the kube directory
JOBS=()

# List of files ending in '.blockingjob.yml' in the kube directory
BLOCKING_JOBS=()

# List of files ending in '.cronjob.yml' in the kube directory
CRONJOBS=()

# List of files ending in '.daemonset.yml' in the kube directory
DAEMONSETS=()
```

## Assumptions
* In your Deployment file, specify imagePullPolicy: IfNotPresent
* When using HPA in your Deployment file, the value of $DEPLOYMENT must match the deployment name or rok8s-scripts will not be able to determine the current number of replicas.

