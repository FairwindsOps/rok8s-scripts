# rok8s-scripts Design Doc

## Introduction

This is a set of opinionated scripts for managing application development and deployment lifecycle using Kubernetes. These simplify secure secrets management, environment specific config, Docker build caching, and much more. The opinionated nature of the scripts reflects the collective experience and observed best-practices that Fairwinds has accumulated.

## Guiding Principles

There are several things that are to be kept in mind while maintaining rok8s-scripts.. They should act as baseline from which to make decisions.

**Ease of Use**
It should be relatively trivial to take an existing Dockerized application and construct a pipleline to build and deploy it using rok8s-scripts.

**Backward Compatibility**
When introducing a new feature to rok8s-scripts, it should be backward-compatible.  If it might break something, we prefer to contain it inside of an environment variable feature flag in order to make the feature optional. If this is not possible, sufficient care should be taken to notify customers and increment version accordingly.

**Scope**
As maintainers of rok8s-scripts, Fairwinds is not in the business of catering to every single hand-crafted bespoke pipeline in existence. This means that some changes may be out of scope for the intended purpose. The intended purpose is to build, push, and deploy containers.

**Pull Requests Welcom**
Please don't hesistate to reach out and file a PR or an Issue if you would like to see something implemented. See [CONTRIBUTING](CONTRIBUTING.md)
