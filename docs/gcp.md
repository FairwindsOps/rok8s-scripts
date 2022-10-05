---
meta:
  - name: description
    content: "Fairwinds rok8s Scripts | Deploying to Google Cloud"
---
# Deploying to Google Cloud
It's quite straightforward to push Docker images to Google Container Registry and deploy to GKE clusters with rok8s-scripts.

## Google Cloud Credentials
To connect to Google Cloud from a CI workflow, a [GCP service account](https://console.cloud.google.com/iam-admin/serviceaccounts)
is recommended. To create a service account:
* [Go to the service accounts page](https://console.cloud.google.com/iam-admin/serviceaccounts)
* Choose a name for the account (e.g. `rok8s-scripts`) and hit "Create"
* For "Service account permissions", choose `Kubernetes Engine Developer` and hit "continue"
* Click "Create Key" and choose "JSON"


To load the JSON credentials into a rok8s-scripts CI workflow, they'll need to be base64 encoded.
This can be accomplished with a command like this:

```bash
cat downloaded_google_credentials.json | base64 -w 0
```

With those credentials in base64 format, you'll need to add them as a protected environment variable in your CI tool of choice. This environment variable needs to be named `GCLOUD_KEY`, and contain a base64 encoded copy of GCP Service Account credentials. It's important that this value is not checked into your codebase, as the credentials could potentially provide a great deal of access into your systems.

## Google Cloud Configuration
With the credentials properly configured, there are a few more environment variables that need to be set:

1. `GCP_PROJECT`
The Google Cloud project that you'll be working with.

2. `GOOGLE_APPLICATION_CREDENTIALS`
A path for the decoded `$GCLOUD_KEY` to be stored. A simple value like `/tmp/gcloud_key.json` is generally sufficient here.

## Optional Google Cloud Configuration
You can optionally specify a registry to use when using the prepare-gcloud script:

1. `GCP_IMG_REPO`
The registry to pass to the `gcloud auth configure-docker` command. If omitted the google default is used. See [here.](https://cloud.google.com/sdk/gcloud/reference/auth/configure-docker)

## Google Kubernetes Engine Configuration
The configuration above is sufficient to connect to a GCP project and pull or push images, but more configuration is required to connect to a GKE cluster.

1. `CLUSTER_NAME`
The name of the GKE cluster to connect to.

### Regional Clusters
1. `GCP_REGIONAL_CLUSTER`
Set this variable to `true` if the cluster to connect to is regional.

2. `GCP_REGION`
The GCP region the cluster is in.

### Zonal Clusters
1. `GCP_ZONE`
The GCP zone the cluster is in.

## Connecting to Google Cloud
With the above environment variables in place, it's time to run a script to pull it all together and configure the Google Cloud CLI:

```bash
prepare-gcloud
```
