[![Version][version-image]][version-link] [![CircleCI][circleci-image]][circleci-link]

[version-image]: https://img.shields.io/static/v1.svg?label=Version&message=8.1.0&color=239922
[version-link]: https://github.com/reactiveops/rok8s-scripts/releases
[circleci-image]: https://circleci.com/gh/reactiveops/rok8s-scripts.svg?style=svg
[circleci-link]: https://circleci.com/gh/reactiveops/rok8s-scripts

# rok8s-scripts

rok8s-scripts is a framework for building GitOps workflows with Docker and Kubernetes.
By adding rok8s-scripts to your CI/CD pipeline, you can build, push, and deploy your applications using the
set of best practices we've built at ReactiveOps.

In addition to building Docker images and deploying them to Kubernetes, rok8s-scripts is a great way to handle
secure secrets management, environment specific configuration, Docker build caching, and much more.

**Want to learn more?** ReactiveOps holds [office hours on Zoom](https://zoom.us/j/242508205) the first Friday of every month, at 12pm Eastern. You can also reach out via email at `opensource@reactiveops.com`

### Quickstart
To help you get started quickly, we've built a [minimal example](https://github.com/reactiveops/rok8s-scripts/tree/master/examples/minimal)
that shows how to use rok8s-scripts to build Docker images and deploy to Kubernetes
using Circle CI. This example will serve as a helpful introduction regardless of your CI platform.

## Documentation
We've created documentation for several different use cases and workflows where rok8s-scripts can help.

* [Build and push Docker images](docker.md) - This is the place to start to get a sense
for rok8s-scripts project structure and a very basic use case
* [Deploy to Kubernetes](without_helm.md) - Learn how to get your applications into staging
and production.
* [Deploy to Kubernetes with Helm](helm.md) - If you've built a Helm chart for your application,
rok8s-scripts is a great way to deploy your chart to staging and production
* [Manage secrets](secrets.md) - Learn how rok8s-scripts can simplify and secure your secret management workflows

### Cloud-specific Documentation
* [Deploy to AWS](aws.md) - Learn how to authenticate and deploy using rok8s-scripts with aws-cli
* [Deploy to GCP](gcp.md) - Learn how to authenticate and deploy using rok8s-scripts with gcloud

## Examples

rok8s-scripts is designed to work well with a wide variety of use cases and environments.
There are many valid ways to configure CI pipelines, but to help you get started, we've included a variety of [examples](https://github.com/reactiveops/rok8s-scripts/tree/master/examples) in this repository.

### CI Platforms
- [Bitbucket Pipelines](https://github.com/reactiveops/rok8s-scripts/tree/master/examples/ci/bitbucket-pipelines.yml)
- [CircleCI](https://github.com/reactiveops/rok8s-scripts/tree/master/examples/ci/.circleci/config.yml)
- [GitLab CI](https://github.com/reactiveops/rok8s-scripts/tree/master/examples/ci/.gitlab-ci.yml)
- [Jenkins](https://github.com/reactiveops/rok8s-scripts/tree/master/examples/ci/Jenkinsfile)

### Miscellaneous examples
- [External secrets manager](https://github.com/reactiveops/rok8s-scripts/tree/master/examples/external-secrets-manager)
- [SOPS secrets](https://github.com/reactiveops/rok8s-scripts/tree/master/examples/sops-secrets) - Shows how to use [sops](https://github.com/mozilla/sops) with rok8s-scripts
- [Using Helm](https://github.com/reactiveops/rok8s-scripts/tree/master/examples/helm) - We recommend using Helm to manage your deployments
- [Optional components](https://github.com/reactiveops/rok8s-scripts/tree/master/examples/optional-components) - Turn components (e.g. Horizontal Pod Audoscaler) on and off depending on whether you're deploying to staging or production
- [Production ready](https://github.com/reactiveops/rok8s-scripts/tree/master/examples/production-ready) - Includes a number of recommended production features

## CI Images

Each new release of rok8s-scripts generates CI images for common workflows. These images include a set of common CI/CD dependencies, including Docker, Kubernetes, Helm, AWS, and Google Cloud client libraries. Starting with these images as a base for deployment workflows ensures that you don't need to spend any build time installing extra dependencies.

We currently include CI Images based on Alpine and Debian Stretch as our recommended starting points. The latest Debian Stretch release can be pulled from `quay.io/reactiveops/ci-images:v8-stretch`. A full list of image tags is available on our [Quay repository](https://quay.io/repository/reactiveops/ci-images).

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


### Contributing
- [Code of Conduct](https://github.com/reactiveops/rok8s-scripts/tree/master/CODE_OF_CONDUCT.md)
- [Releasing New Versions of rok8s-scripts](releasing.md)

## License
Apache License 2.0
