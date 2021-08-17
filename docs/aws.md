---
meta:
  - name: description
    content: "Fairwinds rok8s Scripts | Deploying to AWS"
---
# Deploying to AWS
It's quite straightforward to push Docker images to AWS ECR and deploy to Kubernetes clusters running AWS IAM Authenticator with rok8s-scripts.

## AWS Credentials
rok8s-scripts uses the AWS CLI and expects it to have appropriate credentials in place. One of the simplest ways to do that involves setting the following environment variables:

- `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

More information about configuring the AWS CLI is available from the [official AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html). It's important to note that sensitive credentials like `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` should never be checked into your codebase. Instead, most CI systems, including CircleCI, GitLab CI, and Bitbucket Pipelines, include a way of configuring sensitive credentials for each project.

## AWS ECR Docker Auth
With AWS credentials properly configured, you can run the following script to get Docker credentials for pulling from and pushing to an ECR repo.

```
prepare-awscli
```

## AWS IAM Authenticator
The standard authentication mechanism for Kubernetes clusters running on AWS has quickly become [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator). The required client binary is included as part of all rok8s-scripts CI Images.

## Kubernetes Configuration
Connecting to Kubernetes clusters on AWS works the same as it would anywhere else. A valid kubeconfig file is needed in a base64 encoded format. That can be accomplished by a command like this:

```bash
cat valid-kube-config-file.json | base64
```

That base64 encoded value is expected to be in a `KUBECONFIG_DATA` environment variable. This value usually contains sensitive information and therefore should be kept out of your codebase and instead loaded as a protected variable in your CI platform. With this value set, the following command will set up your Kubernetes configuration for your pipeline:

```bash
prepare-kubectl
```
