[![CircleCI](https://circleci.com/gh/reactiveops/rok8s-scripts.svg?style=svg)](https://circleci.com/gh/reactiveops/rok8s-scripts)

# rok8s-scripts

This is a set of opinionated scripts for managing application development and deployment lifecycle using Kubernetes. These simplify secure secrets management, environment specific config, Docker build caching, and much more.

## CI Images

Each new release of rok8s-scripts comes with a new set of CI images for simple workflows. These CI images include a set of common CI/CD dependencies, including Docker, Kubernetes, Helm, AWS, and Google Cloud client libraries. Starting with these images as a base for deployment workflows should ensure that you don't need to spend any build time installing extra dependencies.

We currently include a variety of CI Images, including Alpine and Debian Stretch as our recommended starting points. In certain cases you may want to use our images that include Node.js or Golang.

The latest Debian Stretch release can be pulled from `quay.io/reactiveops/ci-images:v8-stretch`. A full list of the latest image tags is available on our [Quay repository](https://quay.io/repository/reactiveops/ci-images).

## Examples

rok8s-scripts is designed to work well in a wide variety of environments. That includes Bitbucket Pipelines, CircleCI, GitLab CI, and more. There are many valid ways to configure CI pipelines, we've includes a variety of [examples](/examples) in this repository.

Most notably, the CI example includes sample configuration for the following platforms:

- [Bitbucket Pipelines](/examples/ci/bitbucket-pipelines.yml)
- [CircleCI](/examples/ci/.circleci/config.yml)
- [GitLab CI](/examples/ci/.gitlab-ci.yml)
- [Jenkins](/examples/ci/Jenkinsfile)

On their own, these examples may not make a lot of sense. There's a lot more documentation below that should cover everything included in these examples and more.

## Versioning v8.0.0 and beyond

Rok8s-scripts contains a number of dependencies that have various ways of versioning themselves. Most notably, Helm tends to break backward compatibility with every minor release. We have decided that post v8 of rok8s-scripts, we will update our versions according to the version change of the underlying tool. For example, if Helm changes from `2.13.0` to `2.14.0`, we will change the version of rok8s scripts by one minor version. This will be clearly mentioned in the release notes. This means that a minor version of rok8s-scripts could introduce breaking changes to the CI/CD pipelines that are using it.

Please note that we will still commit to any patch version releases being backward-compatible. We will never release a patch version that upgrades an underlying tool beyond a patch version, and we will not release any patch versions of rok8s-scripts that introduce a breaking change.

Here is a set of guidelines to follow when deciding what version of ci-images (and thus rok8s-scripts) to use:

#### You are very risk-averse

You want rok8s-scripts to be stable, and just keep working until you decide to upgrade.

In this scenario, you should pin to a minor version of rok8s-scripts such as `v8.0-alpine`.

#### You like to live dangerously

You are okay with your pipeline breaking occasionally and having to upgrade things as they break.

In this case, go ahead and pin to a major version such as `v8-alpine`

## Further Reading

- [Building and Pushing Docker Images](/docs/docker.md)
- [Deploying to Kubernetes with Helm](/docs/helm.md)
- [Deploying to Kubernetes without Helm](/docs/without_helm.md)
- [Managing Kubernetes Secrets Securely](/docs/secrets.md)

### Cloud Specific Documentation
- [Amazon Web Services](/docs/aws.md)
- [Google Cloud](/docs/gcp.md)

### Contributing
- [Releasing New Versions of rok8s-scripts](/docs/releasing.md)

## License
Apache License 2.0
