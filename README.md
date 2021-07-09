<div align="center">
    <img src="/img/rok8s-logo.svg" height="120" alt="Rok8s Scripts" />
    <br>
    <a href="https://github.com/FairwindsOps/rok8s-scripts/releases">
        <img src="https://img.shields.io/github/v/release/FairwindsOps/rok8s-scripts">
    </a>
    <a href="https://join.slack.com/t/fairwindscommunity/shared_invite/zt-e3c6vj4l-3lIH6dvKqzWII5fSSFDi1g">
      <img src="https://img.shields.io/static/v1?label=Slack&message=Join+our+Community&color=4a154b&logo=slack">
    </a>
</div>

rok8s-scripts is a framework for building GitOps workflows with Docker and Kubernetes.
By adding rok8s-scripts to your CI/CD pipeline, you can build, push, and deploy your applications using the
set of best practices we've built at Fairwinds.

In addition to building Docker images and deploying them to Kubernetes, rok8s-scripts is a great way to handle
secure secrets management, environment specific configuration, Docker build caching, and much more.

## Join the Fairwinds Open Source Community

The goal of the Fairwinds Community is to exchange ideas, influence the open source roadmap, and network with fellow Kubernetes users. [Chat with us on Slack](https://join.slack.com/t/fairwindscommunity/shared_invite/zt-e3c6vj4l-3lIH6dvKqzWII5fSSFDi1g) or [join the user group](https://www.fairwinds.com/open-source-software-user-group) to get involved!

# Documentation
Check out the [full documentation at docs.fairwinds.com](https://rok8s-scripts.docs.fairwinds.com/)

### Quickstart
To help you get started quickly, we've built a [minimal example](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/minimal)
that shows how to use rok8s-scripts to build Docker images and deploy to Kubernetes
using Circle CI. This example will serve as a helpful introduction regardless of your CI platform.

## Examples

rok8s-scripts is designed to work well with a wide variety of use cases and environments.
There are many valid ways to configure CI pipelines, but to help you get started, we've included a variety of [examples](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples) in this repository.

### CI Platforms
- [Bitbucket Pipelines](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/ci/bitbucket-pipelines.yml)
- [CircleCI](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/ci/.circleci/config.yml)
- [GitLab CI](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/ci/.gitlab-ci.yml)
- [Jenkins](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/ci/Jenkinsfile)

### Miscellaneous examples
- [External secrets manager](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/external-secrets-manager)
- [SOPS secrets](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/minimal-sops-secrets) - Shows how to use [sops](https://github.com/mozilla/sops) with rok8s-scripts.
- [Using Helm](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/helm) - We recommend using Helm to manage your deployments.
- [Production ready](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/production-ready) - Includes a number of recommended production features.


## Other Projects from Fairwinds

Enjoying rok8s-scripts? Check out some of our other projects:
* [Polaris](https://github.com/FairwindsOps/Polaris) - Audit, enforce, and build policies for Kubernetes resources, including over 20 built-in checks for best practices
* [Goldilocks](https://github.com/FairwindsOps/Goldilocks) - Right-size your Kubernetes Deployments by compare your memory and CPU settings against actual usage
* [Pluto](https://github.com/FairwindsOps/Pluto) - Detect Kubernetes resources that have been deprecated or removed in future versions
* [Nova](https://github.com/FairwindsOps/Nova) - Check to see if any of your Helm charts have updates available
* [rbac-manager](https://github.com/FairwindsOps/rbac-manager) - Simplify the management of RBAC in your Kubernetes clusters

Or [check out the full list](https://www.fairwinds.com/open-source-software?utm_source=rok8s-scripts&utm_medium=rok8s-scripts&utm_campaign=rok8s-scripts)
