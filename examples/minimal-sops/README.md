# Minimal Example for rok8s-scripts

This is an example rok8s-scripts configuration that deploys a NodeJS application
to production. It is built for CircleCI, but should help give a basic overview of
the pieces of a rok8s-scripts deployment regardless of your CI platform.

## Configuration
The file [`./deploy/production.config`](./deploy/production.config) is the main entry point for rok8s-scripts.
It tells rok8s-scripts how to build the image and what registry to push it to.

## CI/CD
The file [`./.circleci/config.yml`](./.circleci/config.yml) is the main entry point for CircleCI. In it,
we run some of the scripts provided by rok8s-scripts. In particular, we use:

* `docker-pull` to get the last image we pushed, which warms the local docker cache for faster builds
* `docker-build` to build the image for the current commit
* `docker-push` to push the image for the current commit to our image repository
* `prepare-kubectl` to configure the `kubectl` command to be able to deploy resources to our Kubernetes cluster
* `k8s-deploy-and-verify` to deploy our image to Kubernetes and make sure the deployment succeeded
	* This also calls the `k8s-deploy-secrets` script to decrypt and deploy secrets

We also use the rok8s-scripts CI image, `quay.io/reactiveops/ci-images:v9-stretch`,
to ensure rok8s-scripts and its dependencies are available during the build and deploy jobs.

## Try it out

* Run the following to copy this directory to a new git repository:
```
git clone https://github.com/FairwindsOps/rok8s-scripts
cp -r rok8s-scripts/examples/minimal rok8s-scripts-test
cd rok8s-scripts-test
git init
git add .
git commit -m "testing rok8s scripts"
```
* Create a new repository on GitHub
* Follow the instructions on GitHub to push your code to your new repo
* Go to circleci.com and add your repo as a new project
* Click "Start Building" to kick off your first build

You'll see CircleCI start two jobs - one to build the image, and one to deploy it to Kubernetes.
The build job should succeed, but the deploy job will fail, because we haven't configured
credentials for our image repository or Kubernetes cluster.

### Encrypt the secret

This deployment leverages the `k8s-deploy-secrets` script to decrypt and deploy a secret to Kubernetes. Encrypt the included secret , and commit **the encrypted secret** to this repository. The unencrypted secret is included in this repository **only for demonstration purposes**, and is not used by the rok8s-scripts deployment.

* Install the [Sops](https://github.com/mozilla/sops) tool, to encrypt the secret.
* See the [Sops section of the secrets documentation](./../../docs/secrets.md#encrypted-secrets-with-sops) for details about creating an encryption key and encrypting secrets. Use a command like one of the following to encrypt the secret in this repository. NOTE: Be sure to set the `sops_kms_flag` variable below, to the correct Sops flag and KMS ID for your cloud provider (AWS or GCP):

```
# Set this to an appropriate value for your AWS or GCP KMS key.
# Replace the placeholders in braces {} with your values.
# For Google Cloud:
sops_kms_flag='--gcp-kms  projects/{project name}/locations/{region or global}/keyRings/{keyring name}/cryptoKeys/{KMS key name}'
#
# For Amazon Web Services:
sops_kms_flag='--kms arn:aws:kms:{region}:{account id}:key/{KMS key ID}'
#
sops --encrypt \
$sops_kms_flag \
./deploy/minimal-sops-production.secret.unencrypted.yml \
> ./deploy/minimal-sops-production.secret.sops.yml
# Commit the encrypted secret to your repository
git add ./deploy/minimal-sops-production.secret.sops.yml
git commit -m 'Add encrypted secret' ./deploy/minimal-sops-production.secret.sops.yml
git push
```

### Setting up the image repository
These instructions are for quay.io, and will have to be adapted if you're
using another image registry like AWS ECR, GCP GCR, or DockerHub.

* Set up a new repo on quay.io
* Create a new [robot account](https://docs.quay.io/glossary/robot-accounts.html)
* Click the settings icon next to the robot account, and click "View credentials"
* In your project settings on CircleCI, go to "Environment Variables"
* Add an environment variable named `quay_robot`, and paste the value from Quay
* Add an environment variable named `quay_token`, and paste the value from Quay
* Update the rok8s-scripts configuration and Kubernetes deployment with the image registry:
	* Edit `./deploy/production.config` with your quay organization and repository name, by setting `EXTERNAL_REGISTRY_BASE_DOMAIN` and `REPOSITORY_NAME`
	* Edit `./deploy/minimal-production.deployment.yml` with your quay organization and repository name, by setting `image` under `spec -> template -> spec -> containers -> *`

### Setting up Kubernetes
> Note: Using your personal kubeconfig is NOT recommended. It is much more secure
> to create a service account. See the docs on [Kubernetes auth](/docs/kubernetes_auth.md)
> for more details
In order to deploy to Kubernetes, you'll need to base64 encode a valid kubeconfig
and set it as an environment variable in CircleCI. We strongly recommend
[creating and using a service account](/docs/kubernetes_auth.md) for this step, but for simplicity
the example below uses the kubeconfig stored in your home directory.

* Run:
```
cat ~/.kube/config | base64 -w 0 > kube-config-encoded.txt
```
* Create a new environment variable in CircleCI called `KUBECONFIG_DATA`
* Paste the contents of `kube-config-encoded.txt` as the environment variable value

### Rerun the build
Commit and push your changes to the master branch to trigger another build.
Everything should run successfully this time, and you should see your app
running inside your Kubernetes cluster.

You can check your app by running
```
kubectl port-forward --namespace rok8s-example svc/rok8s-example 3000:80
```
and visiting `localhost:3000` in your browser.

### Cleaning up

To remove this example from your Kubernetes cluster, delete the namespace where it was deployed. See the `NAMESPACE` line of your [`./deploy/production.config`](./deploy/production.config) file.

For example: `kubectl delete namespace rok8s-example`

You may also want to remove the Github repository you created.
