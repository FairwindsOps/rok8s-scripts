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

# List of secrets to pull from S3
S3_SECRETS=()

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
* Secrets end in `secret.yml`
* ConfigMaps end in `configmap.yml`
* Persistent Volumes end in `persistent_volume.yml`
* Persistent Volume Claims end in `persistent_volume_claim.yml`
* Statefulsets end in `statefulset.yml`
* Services end in `service.yml`
* Blocking Jobs end in `blockingjob.yml`
* Jobs end in `job.yml`
* Ingress Resources end in `ingress.yml`
* Pod Disruption Budgets end in `pod_disruption_budget.yml`

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

### k8s-deploy

`kubectl apply`'s files in the config.

**If a Docker image is used in the file then any cases of `:latest` will be replaced with th `CI_SHA1` if it is defined.** This allows a set image tag to be used when deploying from a CI system. When files that could use `CI_SHA1` is are deployed, a new file will be created with that value as part of the filename.

Leverages kubernetes annotations with `--record` when creating objects.

### k8s-verify

Verifies your deployment was successful within a specified timeout.

### k8s-deploy-and-verify

Combines `k8s-deploy` and `k8s-verify` into a single command. This can be used to keep a smaller script/deployment config and for backwards compatibility.

### k8s-delete

Nukes everything defined in your k8s-scripts config file.

### k8s-secrets-from-s3

Generates a kubernetes secrets YAML file from the contents of a path within an S3 bucket. This will copy files from `${S3_BUCKET}/${NAMESPACE}/${SECRET}` and generate a file into `deploy/${SECRET}.secret.yaml`, suitable for deployment with `k8s-deploy`.

This script assumes that [`aws-cli`](https://pypi.python.org/pypi/awscli) is installed and that AWS credentials with appropriate permissions are available to the CLI.

Example permissions:

```
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:Get*",
              "s3:List*"
          ],
          "Resource": [
            "arn:aws:s3:::${S3_BUCKET}",
            "arn:aws:s3:::${S3_BUCKET}/*"
          ]
      }
  ]
}
```

Secrets across clusters in the same namespace are not easily supported with this method as cluster names are not used. If you need to use the same namespace across different clusters (`kube-system` for example) then you should create separate buckets.

Each file in `${S3_BUCKET}/${NAMESPACE}/${SECRET}` will be a single entry in the Kubernetes Secret `${SECRET}`

An S3 bucket layout of:

```
production/
  example-secret/
    username
    password
```

With the file `username` containing `example-username` and `password` containing `example-password` would generate a secret of

```
apiVersion: v1
kind: Secret
metadata:
  creationTimestamp: null
  name: example-secret
data:
  username: example-username
  password: example-password
```

### k8s-sops-secret-decrypt

Given an [AWS KMS](https://aws.amazon.com/kms/) key id, decrypts a file which is a kubernetes secret YAML. The encrypted secret file is safe to store in git.

The script assumes [sops](https://github.com/mozilla/sops.git) is installed and the `SOPS_KMS_ARN` environment variable is set. Ensure your `circle.yml` installs sops. I.e. add, `go get -u go.mozilla.org/sops/cmd/sops` to the `dependencies` level.

If run from circleci, the script also assumes that the circleci IAM user has proper privileges to decrypt secrets using the set key.

An example IAM policy might look like this:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "circle-decrypt",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey"
            ],
            "Resource": [
                "arn:aws:kms:<region>:<accountId>:key/<key>"
            ]
        }
    ]
}
```

A procedure for _encrypting_ secrets with sops might look this this:

Encrypt [secret spec files](https://kubernetes.io/docs/concepts/configuration/secret/) with [sops](https://github.com/mozilla/sops)
  eg. `sops --kms="<your kms key arn>" --encrypt mysecret.yaml` _



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

### ensure-kubectl
Makes sure kubectl is installed and available for use. Customize the version
by specifying the `KUBECTL_VERSION` envrionmental variable. Default: `v1.3.6`.


## Assumptions

* In your Deployment file, specify imagePullPolicy: IfNotPresent

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
