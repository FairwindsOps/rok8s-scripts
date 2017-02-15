# Kubernetes Scripts

Opinionated scripts for managing application development and deployment lifecycle using Kubernetes.

## How to Install

```
npm install reactiveops/k8s-scripts
export PATH="$(PWD)/node_modules/.bin:$PATH"
```

Then in your top-level project directory:
```
k8s-example-config
```

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

# List of secrets to pull from S3
S3_SECRETS=()

# List of files ending in '.persistent_volume.yml' in the kube directory
PERSISTENT_VOLUMES=('example-app')

# List of files ending in '.persistent_volume_claim.yml' in the kube directory
PERSISTENT_VOLUME_CLAIMS=('example-app')

# List of files ending in '.service.yml' in the kube directory
SERVICES=('example-app')

# List of files ending in '.endpoint.yml' in the kube directory
ENDPOINTS=()

# List of files ending in '.ingress.yml' in the kube directory
INGRESSES=()

# List of files ending in '.deployment.yml' in the kube directory
DEPLOYMENTS=('example-app')

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
* Services end in `service.yml`
* Blocking Jobs end in `blockingjob.yml`
* Jobs end in `job.yml`
* Ingress Resources end in `ingress.yml`

## Commands

### docker-build

Does a build of the current directory
`docker build --rm=false -t $DOCKERTAG -f ${BASEDIR}/$DOCKERFILE ${BASEDIR}``

### docker-pull

Pulls from the registry the most recent build of the image. Useful for CI/CD layer caching

### docker-push

Pushes the recently build image to the registry

### k8s-deploy

Generates $CI_SHA1 suffixs for each of the files defined in your k8s-scripts config and uses
`kubectl create` if the objects don't exist, `kubectl apply` if they do.

Leverages kubernetes annotations with `--record` when creating objects.

Verifies your deployment was successful within a specified timeout.

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

This repo follows the [ReactiveOps release process](https://github.com/reactiveops/docs/blob/master/engineering/software-releases.md).
