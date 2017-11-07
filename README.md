# Kubernetes Scripts

Opinionated scripts for managing application development and deployment lifecycle using Kubernetes.

## How to Install

```
npm install rok8s-scripts
export PATH="$(PWD)/node_modules/.bin:$PATH"
```

Then in your top-level project directory:
```
k8s-example-config
```

## Examples

Explore the `examples/` directory for example files.

## Config file

k8s-scripts all function based on a simple bash config file in the root of your project directory named 'k8s-scripts.config'.

```
# Dockerfile to build
DOCKERFILE='Dockerfile'

# Docker tag that will be created
DOCKERTAG='quay.io/exampleorg/example-app'

# Cluster Namespace to work in
NAMESPACE='default'

# List of files ending in '.configmap.yml' in the kube directory
CONFIGMAPS=()

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

# List of helm charts to deploy from ./charts/
CHARTS=()

# List of helm chart values files ending in '.yml' to deploy with the helm charts
CHARTS_VALUES=()

```

### Generating a config

There is a `k8s-example-config` script that will output an example config for you.

`k8s-example-config`
Outputs an example config to k8s-scripts.config

`k8s-example-config -o k8s-scripts.prod.config`
Outputs an example config to the filename specified by -o flag.

### Supporting multiple environments

All scripts take an `-f configfile` option that allows you to specify which configuration file to use.

We recommend having the default, k8s-scripts.config, setup for your minikube environment, then
specify `<env>.conf` for each of your environments.

## deploy directory

Your kubernetes API object files should all be stored in the /deploy top level directory using consistent naming:

* Deployments end in `deployment.yml`
* Unencrypted Secrets end in `secret.yml`
* Encrypted Secrets end in `secret.sops.yml`
* External Secrets end in `external`
* ConfigMaps end in `configmap.yml`
* Persistent Volumes end in `persistent_volume.yml`
* Persistent Volume Claims end in `persistent_volume_claim.yml`
* Statefulsets end in `statefulset.yml`
* Services end in `service.yml`
* Blocking Jobs end in `blockingjob.yml`
* Jobs end in `job.yml`
* Ingress Resources end in `ingress.yml`
* Pod Disruption Budgets end in `pod_disruption_budget.yml`

## Credentials

If you are using `rok8s-scripts` to deliver images to a cloud repository on AWS or GCP you will need to provide credentials as environment variables. `rok8s-scripts` will automatically login if the following variables exist:

### AWS [Access Keys](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

### GCP
* `GCLOUD_KEY` [Service Account Keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)

## Kubernetes Access

In order to connect to a Kubernets cluster the build must authenticate. In GKE clusters having the above GCP login is sufficient. In other clusters, base64encode your kube_config file and save it in the environment variable `KUBECONFIG_DATA`

## Secrets

There are multiple ways to handle Kubernetes Secrets. Examples of each can be
found in [here](examples/sops-secrets).

### Unencrypted

This isn't recommended, but you can store you `Secret` manifests directly in your
source code. Use the `SECRETS=` configuration to specify the manifests to deploy.

### Encrypted

Using an [AWS KMS](https://aws.amazon.com/kms/) ARN or [Google KMS](https://cloud.google.com/kms/) ID, `Secret` manifests are encrypted in the source code and decrypted at deployment time.

Whenever encrypting or decrypting data, `sops` requires credentials for the appropriate
cloud provider (GCP or AWS). You can read more about `sops` usage [here](https://github.com/mozilla/sops#usage).

```bash
sops "--kms=arn:aws:kms:us-east-1:123456123456:key/e836b432-b1db-4b84-a124-6c54948d787c" --encrypt secret.yml > deploy/encrypted.secret.sops.yml
echo 'SOPS_SECRETS=(encrypted)' >> app.config
echo 'SOPS_KMS_ARN=arn:aws:kms:us-east-1:123456123456:key/e836b432-b1db-4b84-a124-6c54948d787c' >> app.config
```

### External

You can also store your secrets in either the Google Storage or S3 object store.
During deployment, secrets are copied from the object store into `Secret` manifests so
they are never committed to the repository. You edit and manage permissions for them
using the IAM permissions for your cloud provider.

When deploying, credentials for the cloud provider must be available.

Doing something like this:
```bash
mkdir mysecrets
echo -n 'asdfasdf' > mysecrets/password.txt
echo -n 'root' > mysecrets/username.txt
gsutil rsync mysecrets/ s3://exampleorg/production/mysecrets
echo 's3://exampleorg/production/mysecrets' > deploy/web-config.secret.external
echo 'EXTERNAL_SECRETS=(web-config)' >> app.config
```

Will generate a secret like this:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: web-config
data:
  username.txt: cm9vdCAtbgo=
  password.txt: YXNkZmFkc2YgLW4K
```

### Updating an existing Secret file for use with Google Cloud

#### Setup

1. From the repo's `deploy` directory, run `gcloud auth application-default login`.
1. A browser window will open.  Log in with your Google account.
1. Your terminal will return saying that credentials have been saved.
1. Run `unset GOOGLE_APPLICATION_CREDENTIALS`

#### Decrypting

1. open your `<app>.secret.sops.yml`, and grab the value for `sops/kms/gcp_kms/resource_id`
1. `sops --decrypt --input-type yml --gcp-kms <resource_id> <env>/<app>.secret.sops.yml > <env>/<app>.secret.yml`
  * "Note that the first filename in this command is the encrypted file (i.e. with `.sops`) and the second filename is the decrypted file (i.e. without `.sops`)"

#### Encrypting

With the above `resource_id` in-hand...

1. `sops --encrypt --input-type yml --gcp-kms <resource_id> <env>/<app>.secret.yml > <env>/<app>.secret.sops.yml`
1. Ensure that you delete your unencrypted files, `<env>/<app>.secret.yml`


## Commands

### docker-build

Does a build of the current directory
`docker build --rm=false -t $DOCKERTAG -f ${BASEDIR}/$DOCKERFILE ${BASEDIR}``

### docker-pull

Pulls from the registry the most recent build of the image. Useful for CI/CD layer caching

### docker-push

Pushes the recently built image to the registry.

This requires the environment variables:

* `EXTERNAL_REGISTRY_BASE_DOMAIN`
* `REPOSITORY_NAME`
* `DOCKERTAG`
* `CI_SHA1`
* `CI_BUILD_NUM`

And either `CI_BRANCH` or `CI_TAG`

### helm-deploy

Using helm chart(s) to manage release. Helm allows more templateing and DRYer config but increase the complexity of the Kubernetes spec files. Reference the example `./examples/helm` and the helm documentation for assitance creating charts.

### install-rok8s-requirements

Installs all the external requirements for rok8s-scripts. Installs are done
via package management (requiring `sudo`) or by installing things to
`$ROK8S_INSTALL_PATH` which is `/usr/local/bin` by default

### k8s-deploy

`kubectl apply`'s files in the config.

**If a Docker image is used in the file then any cases of `:latest` will be replaced with th `CI_SHA1` if it is defined.** This allows a set image tag to be used when deploying from a CI system. When files that could use `CI_SHA1` is are deployed, a new file will be created with that value as part of the filename.

Leverages kubernetes annotations with `--record` when creating objects.

If using an HPA, set `replicas: hpa` in the deployment file to have k8s-deploy get the current number of replicas from the cluster and deploy that number of replicas. This is a workaround for an open issue (https://github.com/kubernetes/kubernetes/issues/25238).

### k8s-verify

Verifies your deployment was successful within a specified timeout.

### k8s-deploy-and-verify

Combines `k8s-deploy` and `k8s-verify` into a single command. This can be used to keep a smaller script/deployment config and for backwards compatibility.

### k8s-delete

Nukes everything defined in your k8s-scripts config file.

### k8s-lint

Linter to provide quick feedback on files. This should be used as part of your CI testing to lint on each build to discover problems before they stop a deployment.

Example:

```
k8s-lint -f k8s-scripts.config
```

Will exit non-zero on a failure.

Current checks:

* Files referenced in config file exist (does not check for secrets files)
* Deployments contain a `revisionHistoryLimit`
* CronJobs contain a `JobsHistoryLimit`
  * History Limits are supported on kubernetes versions greater than 1.6
  * If cluster version =<1.6, the lint will fail.

### minikube-build
Switches to the minikube kubectl context, builds a Docker image from your current directory within the minikube Docker environment.

### minikube-deploy
Switches the minikube kubectl context, then runs `k8s-deploy`

### minikube-delete
Switches to the minikube kubectl context and deletes
all of the objects associated with the k8s-scripts.config

### minikube-services
Switches to the minikube kubectl context and prints out the accessible ip:port
of any services defined in the config file that are accessible from your local machine

### minikube-services-all
Switches to the minikube kubectl context and prints all the accessible ip:port
of all services that are accessible from your local machine

### prepare-awscli
Uses `aws` to configure Docker to use ECR. This requires:

* `AWS_ECR_ACCOUNT_ID` - The account ID for the ECR account to use.
* `AWS_DEFAULT_REGION` - The region to use
* Standard AWS credentials for `aws`

### prepare-gcloud
Uses `gcloud` to download and configure `kubectl`, configures Docker to use
Container Registry and sets the default GCP projecct. This requires:

* `CLUSTER_NAME` - The short name of the cluster as shown in the GKE dashboard
* `GCP_ZONE` - The zone of the cluster
* `GCP_PROJECT` - The GCP project name (as passed to `gcloud` with `--project`)
* `GCLOUD_KEY` - The base64-encoded service account credentials

### prepare-kubectl
Initializes the Kubernetes config to be used with kubectl using a base64-encoded
config file from the `KUBECONFIG_DATA` variable. If `KUBECONFIG_DATA` is defined
this script will `base64 --decode` and place the value into `KUBECONFIG` to be
used by kubectl.

To generate a `KUBECONFIG_DATA` value you can use `cat ~/.kube/config | base64`.

## Assumptions

* In your Deployment file, specify imagePullPolicy: IfNotPresent
* When using HPA in your Deployment file, the value of $DEPLOYMENT must match the deployment name or rok8s-scripts will not be able to determine the current number of replicas.

# Releasing

Create an annotated tag on the commit you would like to release

`HASH` is the commit-ish to tag.
`VERSION` is the version to tag the `HASH` as. This should be of the form of `v[MAJOR].[MINOR].[PATCH]`, with an appended `-TEXT` as needed.

Follow [Semantic Versioning](http://semver.org).

```
git checkout $HASH
git tag -a $VERSION
```

Create a message with a 1-line subject, a blank line, then a 1+ line description.

The `SUBJECT` will be used as the name of the release. The description will be the description of the release.

It is encouraged (but not required) to include changes for this release in the description along with any helpful release notes.

```
SUBJECT

DESCRIPTION
```

Your tag commit message may look like

```
v0.0.0 Awesome Release Name

Breaking Changes:

* No longer defends against non-awesome debuffs

New Features:

* Add new --awesome flag to enable extra awesomeness!

Bug Fixes:

* Fix infinite loop in weird use case
```

Push your tag with

```
git push $REMOTE $VERSION
```

A Github Release will be created by CircleCI and an NPM package will be pushed to NPMjs.

## Git Hooks

Living in the `githooks` directory are a collection of scripts that may be  
included as git hooks.  The intention is to present a collection of scripts to
present a basic level of validation in an automated fashion.

If there is a single script that you would like to include as a hook, you may
simply symlink it directly.  For example, if I want to verify that my yaml is
valid before a commit, I can symlink that script to the pre-commit hook like so:

`ln -s githooks/lint_yaml .git/hooks/pre-commit`

Note that this will be only impact the local copy of the repo; hooks enabled
will not be committed and pushed, so they will not be received on a pull.  This
effectively makes them "opt-in".
