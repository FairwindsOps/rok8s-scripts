# rok8s-scripts

This is a set of opinionated scripts for managing application development and deployment lifecycle using Kubernetes. These simplify secure secrets management, environment specific config, Docker build caching, and much more.

## CI Images

Each new release of rok8s-scripts comes with a new set of CI images for simple workflows. These CI images include a set of common CI/CD dependencies, including Docker, Kubernetes, Helm, AWS, and Google Cloud client libraries. Starting with these images as a base for deployment workflows should ensure that you don't need to spend any build time installing extra dependencies.

These images should work well on a wide variety of CI/CD tools. We've used them successfully as part of workflows on:

- CircleCI
- GitLab CI
- Bitbucket Pipelines

We currently include a variety of CI Images, including Alpine and Debian Stretch as our recommended starting points. In certain cases you may want to use our images that include Node.js or Golang.

The latest Debian Stretch release can be pulled from `quay.io/reactiveops/ci-images:v7-stretch`. A full list of the latest image tags is available on our [Quay repository](https://quay.io/repository/reactiveops/ci-images).

## Examples

rok8s-scripts is designed to work well in a wide variety of environments. That includes Bitbucket Pipelines, CircleCI, GitLab CI, and more. There are many valid ways to configure CI pipelines, we've includes a variety of [examples](/examples) in this repository.

Most notably, the CI example includes sample configuration for the following platforms:

- [Bitbucket Pipelines](/examples/ci/bitbucket-pipelines.yml)
- [CircleCI](/examples/ci/.circleci/config.yml)
- [GitLab CI](/examples/ci/.gitlab-ci.yml)
- [Jenkins](/examples/ci/Jenkinsfile)

On their own, these examples may not make a lot of sense. There's a lot more documentation below that should cover everything included in these examples and more.

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

