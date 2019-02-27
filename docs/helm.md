# Deploying to Kubernetes with Helm

[Helm](https://helm.sh/) is a popular Kubernetes package manager. To deploy to Kubernetes with Helm, you'll first need to [initialize it in your cluster](https://docs.helm.sh/using_helm#install-helm).

## Initial Project Structure

All rok8s-scripts configuration lives in a `deploy` directory at the root of your project by default. In this example, we have a simple Python app with a Dockerfile in place.

```plaintext
app-dir/
├── deploy/
│   ├── build.config                         // rok8s-scripts build configs
│   ├── charts/                              // All HELM chart configuration for the app
│   │   └── app/
│   │       ├── Chart.yaml
│   │       └── templates/
│   │           ├── app.deployment.yaml
│   │           ├── app-env.configmap.yaml
│   │           ├── app.ingress.yaml
│   │           └── app.service.yaml
│   ├── development/                         // Contains files to deploy to dev environment
│   │   ├── app-env.secret.sops.yml          // Secrets in SOPS: <secret-name>.secret.sops.yml
│   │   └── app.values.yml                   // Helm values: <app>.values.yml
│   └── development.config                   // rok8s-scripts config for development env
├── app.py
├── Dockerfile
├── README.md
└── requirements.txt
```

In the above structure we've added a Helm chart, which we won't be outlining here. The other additional files and folder we'll outline below.

## Configuration
The `deploy/development.config` file here is a rok8s-scripts config file for the development environment.

```bash
NAMESPACE='development'
SOPS_SECRETS=('development/app-env')
HELM_CHARTS=('charts/app')
HELM_RELEASE_NAMES=('app-dev')
HELM_VALUES=('development/app')
```

You'll see that some of these configurations reference _similar_, but not exact, matches to the files above. Note `deploy/development/app.values.yml` translates to `HELM_VALUES=('development/app')`. The `deploy/development/app-env.secret.sops.yml` file translates to `SOPS_SECRETS=('development/app-env')`. **Note that if the files are not named with the expected extensions then rok8s-scripts will not work**.

## Helm Values Files
Helm uses values files to fill in chart templates. In this example, our values file is reference in rok8s-scripts config as `HELM_VALUES=('development/app')`, which maps to reading the `deploy/development/app.values.yml` file. A simple values file might look something like this:

```yaml
---
image: 012345678911.dkr.ecr.us-east-1.amazonaws.com/app
somevalue: anothervalue
```

### Values Set Automatically
The helm-deploy and helm-template scripts set 3 Helm values automatically.

1. `image.tag` is set to the value of `$CI_SHA1`, a value that should represent the Git commit sha for the current build.
2. `rok8sCIRef` refers to the value of `$CI_TAG` if it is set, otherwise defaults to the value of `$CI_BRANCH`.
3. `sanitizedBranch` refers to the value of `$SANITIZED_BRANCH`, a URL safe value we derive from the value of `$CI_BRANCH`. This value can be quite useful for deploying ephemeral environments.

## Secret Management
Helm stores release information in Config Maps. If we deployed Kubernetes Secrets with Helm, they'd also be visible in that Helm release Config Map. To avoid that, we manage secrets separately. Please see [Managing Kubernetes Secrets Securely](secrets.md) for further information.

## Deploying it All
This step assumes that you've already configured access to your cluster in your pipeline. If you have not, refer to our cloud specific documentation covering that first.

With cluster auth in place, and Docker images build, you're ready to deploy this with Helm:

```bash
helm-deploy -f deploy/development.config
```

This script reads the rok8s-scripts config file (`deploy/development.config`) and runs a Helm upgrade or install with the given values files.

Importantly, it will set the `image.tag` value to `CI_SHA1`, a value that should match the tag of your latest pushed image. There's more info available in our [Docker documentation](docker.md) on how these images are tagged and pushed.

## Templating
In addition to the `helm-deploy` script, rok8s-scripts also includes a `helm-template` script that will output the Kubernetes config that Helm would apply as part of the `helm-deploy` script. Usage is identical to `helm-deploy`, of course with no changes actually getting deployed:

```
helm-template -f deploy/development.config
```

## Advanced Configuration

### Multiple Charts
The Helm environment variables here all support multiple values. Each value in each array should line up with the value of the other arrays at that position.

```bash
NAMESPACE='development'
HELM_CHARTS=('charts/app' 'charts/app2')
HELM_RELEASE_NAMES=('app-dev' 'app-2-dev')
HELM_VALUES=('development/app' 'development/app2')
```

### Multiple Releases
Similar to above, we can reuse the same chart but have multiple releases of it with slightly different configuration:

```bash
NAMESPACE='development'
HELM_CHARTS=('charts/app' 'charts/app')
HELM_RELEASE_NAMES=('app-dev' 'app-variant')
HELM_VALUES=('development/app' 'development/app-variant')
```

### Multiple Values Files
In some cases, the values files between environments will be quite similar. A helpful pattern involves using a base values file along with environment specific values files.

```bash
# development.config
NAMESPACE='development'
HELM_CHARTS=('charts/app')
HELM_RELEASE_NAMES=('app-dev')
HELM_VALUES=('shared/app,development/app')

# staging.config
NAMESPACE='staging'
HELM_CHARTS=('charts/app')
HELM_RELEASE_NAMES=('app-dev')
HELM_VALUES=('shared/app,staging/app')
```

### Remote Charts
In some cases, it may make more sense to use a remote chart from a Helm repository. This can be accomplished with a couple extra parameters.

```bash
HELM_REPO_NAMES=('bitnami')
HELM_REPO_URLS=('https://charts.bitnami.com')

HELM_CHARTS=('bitnami/redis')
HELM_RELEASE_NAMES=('redis-dev')
HELM_VALUES=('development/redis')
```
