# Ephemeral Environments in rok8s-scripts

This is an example of how rok8s-scripts could be used to deploy ephemeral environments to your Kubernetes
cluster using helm. These ephemeral environments will be created from any feature branches that are pushed
to the source repository based on a regex match.

## Configuration
The file [`./deploy/ephemeral.config`](./deploy/ephemeral.config) is the main entry point for rok8s-scripts.
It tells rok8s-scripts how to build the image and what registry to push it to. It also includes some information
on what the configuration of the ephemeral environment should look like.

## CI/CD
The file [`./.circleci/config.yml`](./.circleci/config.yml) is the main entry point for CircleCI. In it,
we run some of the scripts provided by rok8s-scripts.

There are two methods of using rok8s-scripts shown in this file. The first is using the CircleCI Orb, and the second
is simply using the rok8s-script ci-images executor.

### From the Orb

* Job: [rok8s-scripts/docker_build_and_push](https://circleci.com/orbs/registry/orb/fairwinds/rok8s-scripts#jobs-docker_build_and_push)
* Executor: [rok8s-scripts/ci-images](https://circleci.com/orbs/registry/orb/fairwinds/rok8s-scripts#executors-ci-images)
* Step: [rok8s-scripts/set_env](https://circleci.com/orbs/registry/orb/fairwinds/rok8s-scripts#commands-set_env)

### From rok8s-scripts ci-images

* `prepare-kubectl` to configure the `kubectl` command to be able to deploy resources to our Kubernetes cluster
* `helm-deploy` to deploy our chart to Kubernetes and make sure the deployment succeeded

## Try it out

* Run the following to copy this directory to a new git repository:
```
git clone https://github.com/FairwindsOps/rok8s-scripts
cp -r rok8s-scripts/examples/ephemeral-environments rok8s-scripts-ephemeral-demo
cd rok8s-scripts-ephemeral-demo
git init
git add .
git commit -m "Initial Commit - Testing rok8s scripts ephemeral environments."
```
* Create a new repository on GitHub
* Follow the instructions on GitHub to push your code to your new repo
* Go to circleci.com/dashboard and add your repo as a new project
* Click "Start Building" to kick off your first build

You'll see CircleCI start two jobs - one to build and push the image, and one to deploy it to Kubernetes. The container build should succeed, but the push and deploy will fail, because we haven't configured credentials for our image repository or Kubernetes cluster.

### Setting up the image repository

These instructions are for quay.io, and will have to be adapted if you're using another image registry like AWS ECR, GCP GCR, or DockerHub.

* Set up a new repo on quay.io
* Create a new [robot account](https://docs.quay.io/glossary/robot-accounts.html)
* Click the settings icon next to the robot account, and click "View credentials"
* In your project settings on CircleCI, go to "Environment Variables"
* Add an environment variable named `quay_token`, and paste the value from Quay
* In the `.circleci/config.yml` file, set the following:
  * Line 41 - set the `password-variable` to the name of the environment variable you created (should be `quay_token`
  * Line 43 - set the username to the name of the bot user you created in quay
* In the [deploy/build.config](deploy/build.config) set the following to your values:
  * EXTERNAL_REGISTRY_BASE_DOMAIN
  * REPOSITORY_NAME

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
running inside your Kubernetes cluster. This will deploy to the staging environment.

You can check your app by running
```
kubectl port-forward --namespace staging-rok8s-demo svc/basic-demo 3000:80
```
and visiting `http://localhost:3000` in your browser.

### Create a feature branch to build an ephemeral environment

In your repo, run the following.

```
git checkout -b feature-awesomesauce
echo "" >> README.md
git commit -am "Dummy commit to trigger ephemeral build"
git push -u origin feature-awesomesauce
```

This should trigger a build in CircleCI which will create a namespace and helm deployment of your branch. After the build completes, you can use this to check:

```
kubectl port-forward -n feature-awesomesauce port-forward svc/basic-demo 3001:80
```
and visiting `http://localhost:3001` in your browser.

This page show now have the title `Ephemeral Branch Demo`

### Cleaning up

To remove this example from your Kubernetes cluster, delete the helm releases and namespaces that were created.

For example:
```
helm delete --purge ephemeral-demo-feature-awesomesauce
helm delete --purge ephemeral-demo-staging
kubectl delete namespace feature-awesomesauce
kubectl delete namespace staging-rok8s-demo
```

You may also want to remove the Github repository you created and the container image(s).
