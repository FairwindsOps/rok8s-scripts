<div align="center">
  <img src="/docs/logo.svg" height="120" alt="Rok8s Scripts" />
  <br>

  [![Version][version-image]][version-link] [![CircleCI][circleci-image]][circleci-link]
</div>


[version-image]: https://img.shields.io/static/v1.svg?label=Version&message=10.1.0&color=239922
[version-link]: https://github.com/FairwindsOps/rok8s-scripts/releases
[circleci-image]: https://circleci.com/gh/FairwindsOps/rok8s-scripts.svg?style=svg
[circleci-link]: https://circleci.com/gh/FairwindsOps/rok8s-scripts

rok8s-scripts is a framework for building GitOps workflows with Docker and Kubernetes.
By adding rok8s-scripts to your CI/CD pipeline, you can build, push, and deploy your applications using the
set of best practices we've built at Fairwinds.

In addition to building Docker images and deploying them to Kubernetes, rok8s-scripts is a great way to handle
secure secrets management, environment specific configuration, Docker build caching, and much more.

**Want to learn more?** Reach out on [the Slack channel](https://fairwindscommunity.slack.com/messages/rok8s-scripts), send an email to `opensource@fairwinds.com`, or join us for [office hours on Zoom](https://fairwindscommunity.slack.com/messages/office-hours)

### Quickstart
To help you get started quickly, we've built a [minimal example](/examples/minimal)
that shows how to use rok8s-scripts to build Docker images and deploy to Kubernetes
using Circle CI. This example will serve as a helpful introduction regardless of your CI platform.

## Documentation
We've created documentation for several different use cases and workflows where rok8s-scripts can help.

* [Build and push Docker images](docs/docker.md) - This is the place to start to get a sense
for rok8s-scripts project structure and a very basic use case.
* [Deploy to Kubernetes](docs/without_helm.md) - Learn how to get your applications into staging
and production.
* [Deploy to Kubernetes with Helm](docs/helm.md) - If you've built a Helm chart for your application,
rok8s-scripts is a great way to deploy your chart to staging and production.
* [Manage secrets](docs/secrets.md) - Learn how rok8s-scripts can simplify and secure your secret management workflows.

### Cloud-specific Documentation
* [Deploy to AWS](docs/aws.md) - Learn how to authenticate and deploy using rok8s-scripts with aws-cli.
* [Deploy to GCP](docs/gcp.md) - Learn how to authenticate and deploy using rok8s-scripts with gcloud.

## Examples

rok8s-scripts is designed to work well with a wide variety of use cases and environments.
There are many valid ways to configure CI pipelines, but to help you get started, we've included a variety of [examples](/examples) in this repository.

### CI Platforms
- [Bitbucket Pipelines](/examples/ci/bitbucket-pipelines.yml)
- [CircleCI](/examples/ci/.circleci/config.yml)
- [GitLab CI](/examples/ci/.gitlab-ci.yml)
- [Jenkins](/examples/ci/Jenkinsfile)

### Miscellaneous examples
- [External secrets manager](/examples/external-secrets-manager)
- [SOPS secrets](/examples/sops-secrets) - Shows how to use [sops](https://github.com/mozilla/sops) with rok8s-scripts.
- [Using Helm](/examples/helm) - We recommend using Helm to manage your deployments.
- [Production ready](/examples/production-ready) - Includes a number of recommended production features.

## CI Images

Each new release of rok8s-scripts generates CI images for common workflows. These images include a set of common CI/CD dependencies, including Docker, Kubernetes, Helm, AWS, and Google Cloud client libraries. Starting with these images as a base for deployment workflows ensures that you don't need to spend any build time installing extra dependencies.

We currently include CI Images based on Alpine and Debian Stretch as our recommended starting points. The latest Debian Stretch release can be pulled from `quay.io/reactiveops/ci-images:v11.1-stretch`. A full list of image tags is available on our [Quay repository](https://quay.io/repository/reactiveops/ci-images).

**Deprecation Notice** As of v10 and onward, alpine and stretch will be the only available images.

## Upgrading from v10 to v11

The v11 series of rok8s-scripts will include [Helm 3](https://helm.sh/blog/helm-3-released/). This will require your cluster to be running Helm3 for it to work.

*WARNING* If you deploy your application with Helm3 and it has already been deployed with Helm 2, you may have issues!!! Please [migrate to Helm 3](https://helm.sh/docs/topics/v2_v3_migration/) before using Rok8s-Scripts v11+!!

## Versioning v8.0.0 and beyond

Rok8s-scripts contains a number of dependencies that have various ways of versioning themselves. Most notably, Helm tends to break backward compatibility with every minor release. We have decided that post v8 of rok8s-scripts, we will update our versions according to the version change of the underlying tool. For example, if Helm changes from `2.13.0` to `2.14.0`, we will change the version of rok8s scripts by one minor version. This will be clearly mentioned in the release notes. This means that a minor version of rok8s-scripts could introduce breaking changes to the CI/CD pipelines that are using it.

Please note that we will still commit to any patch version releases being backward-compatible. We will never release a patch version that upgrades an underlying tool beyond a patch version, and we will not release any patch versions of rok8s-scripts that introduce a breaking change.

Here is a set of guidelines to follow when deciding what version of ci-images (and thus rok8s-scripts) to use:

#### You are very risk-averse

You want rok8s-scripts to be stable, and just keep working until you decide to upgrade.

In this scenario, you should pin to a minor version of rok8s-scripts such as `v11.1-alpine`.

#### You like to live dangerously

You are okay with your pipeline breaking occasionally and having to upgrade things as they break.

In this case, go ahead and pin to a major version such as `v11-alpine`.

## Orb

CircleCI has introduced the concept of reusable config in the form of [Orbs](https://circleci.com/orbs/).  As of rok8s-scripts v9.0.0, Fairwinds publishes an orb called [`fairwinds/rok8s-scripts`](https://circleci.com/orbs/registry/orb/fairwinds/rok8s-scripts) in order to provide easier configuration inside of CircleCI.

## Further Reading

- [Building and Pushing Docker Images](/docs/docker.md)
- [Deploying to Kubernetes with Helm](/docs/helm.md)
- [Deploying to Kubernetes without Helm](/docs/without_helm.md)
- [Managing Kubernetes Secrets Securely](/docs/secrets.md)

### Cloud Specific Documentation
- [Amazon Web Services](/docs/aws.md)
- [Google Cloud](/docs/gcp.md)

### Contributing
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Roadmap](ROADMAP.md)
- [Releasing New Versions of rok8s-scripts](/docs/releasing.md)
- [Changelog](https://github.com/FairwindsOps/rok8s-scripts/releases)

## License
Apache License 2.0
