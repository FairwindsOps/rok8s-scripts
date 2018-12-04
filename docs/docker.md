# Building and Pushing Docker Images
This guide will walk you through building and pushing Docker images with rok8s-scripts. These scripts simplify caching from previously built images.

## Initial Project Structure
All rok8s-scripts configuration lives in a `deploy` directory at the root of your project by default. In this example, we have a simple Python app with a Dockerfile in place. We'll add that `deploy` directory and add a rok8s-scripts build config file (`build.config`).

```plaintext
app-dir/
├── deploy/           // Default directory for rok8s-scripts configs and files
│   └── build.config  // rok8s-scripts build configs
├── app.py
├── Dockerfile
├── README.md
└── requirements.txt
```

This `build.config` file sets a number of environment variables that the Docker related scripts will read from:

```bash
DOCKERFILE=('Dockerfile')
EXTERNAL_REGISTRY_BASE_DOMAIN='012345678911.dkr.ecr.us-east-1.amazonaws.com'
REPOSITORY_NAME='app'
```

In this example, we'll be pushing our image to an AWS ECR repository. There are additional docs for both AWS and Google Cloud that cover authentication. For the purpose of this example, we'll assume the authentication step has already happened.

## Building a Docker Image
The following command runs the rok8s-scripts `docker-build` script to build a Docker image with the `build.config` file.
```bash
docker-build -f deploy/build.config
```

By default, this will attempt to pull the following images, and use them as `--cache-from` flags in the Docker build command:

```
"${EXTERNAL_REGISTRY_BASE_DOMAIN}/${REPOSITORY_NAME}:$PREVIOUS_COMMIT"
"${EXTERNAL_REGISTRY_BASE_DOMAIN}/${REPOSITORY_NAME}:$CI_BRANCH"
"${EXTERNAL_REGISTRY_BASE_DOMAIN}/${REPOSITORY_NAME}:master"
```

## Pushing a Docker Image
Similarly, once that image has been built, we can push and tag it using the `docker-push` script:
```bash
docker-push -f deploy/build.config
```

This will attempt to push the image with the following tags:
```
"${EXTERNAL_REGISTRY_BASE_DOMAIN}/${REPOSITORY_NAME}:${CI_SHA1}"
"${EXTERNAL_REGISTRY_BASE_DOMAIN}/${REPOSITORY_NAME}:${CI_REF}"
"${EXTERNAL_REGISTRY_BASE_DOMAIN}/${REPOSITORY_NAME}:build_${CI_BUILD_NUM}"
```

An important note here is that `$CI_REF` defaults to `$CI_BRANCH`, enabling caching in the build step.

## Change Detection
In some cases it will be beneficial to have an indicator of when a container that was built using the `docker-build` command actually created a new layer, as opposed to it just using cached layers.  There is a feature called `ROK8S_ENABLE_CHANGE_DETECTION` that can help with this.

When set to `true`, `ROK8S_ENABLE_CHANGE_DETECTION` will compare the sha256 of the newly built container with the sha256 of the cached container for that branch.  It will output a file called `.changesDetected`.  This file will container `true` if there were changes, or `false` if the container ID is identical to the cache.
