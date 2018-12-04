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

## Further Reading
- [Building and Pushing Docker Images](/docs/docker.md)
- [Deploying to Kubernetes with Helm](/docs/helm.md)
- [Deploying to Kubernetes without Helm](/docs/without_helm.md)
- [Managing Kubernetes Secrets Securely](/docs/secrets.md)

### Cloud Specific Documentation
- [Amazon Web Services](/docs/aws.md)
- [Google Cloud](/docs/gcp.md)

### CI Specific Documentation
- CircleCI
- GitLab CI
- Bitbucket Pipelines

### Contributing
- [Releasing New Versions of rok8s-scripts](/docs/releasing.md)

## License
Apache License 2.0

