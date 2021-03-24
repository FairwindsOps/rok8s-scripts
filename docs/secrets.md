# Managing Kubernetes Secrets Securely
There are multiple ways to securely manage Kubernetes Secrets with rok8s-scripts. With support for AWS Secrets Manager, Sops encrypted secrets, and fetching secrets from external sources like AWS S3 or Google Cloud Storage, there should be at least one option that works well for you.

The Rok8s-scripts [k8s-deploy-secrets helper script](https://github.com/FairwindsOps/rok8s-scripts/blob/master/bin/k8s-deploy-secrets) decrypts and deploys secrets to Kubernetes. You do not need to call this script directly, it is called by other `deploy` scripts.

## External Secrets Managers
It is possible to retrieve individual key/value pairs from an external secrets manager. Supported secret stores are:

* AWS Secrets Manager - specify a list of AWS secret names to retrieve by setting `AWS_SECRETS`.

There are two ways to use this:
* `. get-secrets` - this will allow you to use the variables as environment variables
* As part of `k8s-deploy-secrets` when you set `EXTERNAL_SECRETS_K8S_NAME`.  This will create a secret in the k8s cluster with all of the secrets from the secret store that you listed.

There is an example [here](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/external-secrets-manager).

## Encrypted Secrets With Sops

Sops and rok8s-scripts can provide a powerful solution to encrypted secret management. This enables you to keep your secrets in source control and track changes to those secrets along with the rest of your Kubernetes configuration. All of this is powered with cloud based KMS from either AWS or GCP. Using an [AWS KMS](https://aws.amazon.com/kms/) ARN or [Google KMS](https://cloud.google.com/kms/) ID, Kubernetes Secret manifests are encrypted in your code repository and decrypted at deployment time.

To access encrypted secrets, users or CI need access to both your Git repository and appropriate IAM credentials for KMS.

Rok8s-scripts expects secret files to include the `.secret.sops.yml` extension. In your Rok8s-scripts configuration file, set the `SOPS_SECRETS` variable to a list of secret files, **not including the extension**. For example: `SOPS_SECRETS=('production/minimal-sops-production')`

An [example of sops usage with rok8s-scripts can be found here](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/minimal-sops-secrets).

### Specifying Multiple Secrets Files

Unlike how it is done in the case of Helm, secrets are only specified globally for a release, so when you have multiple, you should specify a single list. For example:

```
### Here we have two files that contain secrets for this release.
SOPS_SECRETS=('production/my-app-global production/my-app-central')

### Example to illustrate the differences between helm and sops config.
HELM_CHARTS=('charts/my-app')
HELM_RELEASE_NAMES=('my-app-production')
HELM_VALUES=('production/my-app-global,production/my-app-central')
```

### Create Cloud Resources

Create the required KMS key that wil be used to encrypt and decrypt your secrets. We recommend using a separate KMS key per application.

* In AWS, [create a KMS key](https://docs.aws.amazon.com/kms/latest/developerguide/create-keys.html)
* In GCP, [create a KMS keyring and a KMS key](https://cloud.google.com/kms/docs/quickstart) - we recommend creating a single KMS keyring for sops secrets, and a KMS key per application.

We recommend using a tool like [Terraform](http://terraform.io) to manage the above, using these Terraform resources:

* [aws_kms_key](https://www.terraform.io/docs/providers/aws/r/kms_key.html)
* [google_kms_key_ring](https://www.terraform.io/docs/providers/google/d/google_kms_key_ring.html)
* [google_kms_crypto_key](https://www.terraform.io/docs/providers/google/d/google_kms_crypto_key.html)

### Assign IAM Permissions

You will need encrypt and decrypt access to the KMS key, and your CI user will need decrypt access to the KMS key. For details about IAM KMS permissions, see:

* [Using IAM policyes with AWS KMS](https://docs.aws.amazon.com/kms/latest/developerguide/iam-policies.html)
* [GCP KMS predefined roles](https://cloud.google.com/kms/docs/reference/permissions-and-roles#predefined_roles)

### Setting up GCloud SDK and SOPS

You may need to run the following command to assure Sops can access your KMS keys in Google Cloud. If you are experiencing “authorization errors” when trying to follow the sops create/update steps below then you may need to run this command.

```bash
gcloud auth applicaton-default login
```

### Creating a New Encrypted Secret

When encrypting data, `sops` requires credentials for the appropriate
cloud provider (GCP or AWS). You can read more about `sops` usage on [the sops usage page](https://github.com/mozilla/sops#usage).

Sops, by default, will open a file in memory to create and encrypt. If you want to encrypt a new file you can run the commands below. Note that if you want to override your terminals default editor (usually set to `vi`) then you can provide an `$EDITOR` environment variable. Included is an example of using sops with vscode (note not all editors are supported).

```bash
### Encrypt using an AWS KMS key
### The value to the --kms argument should be an ARN of the form
## arn:aws:kms:your_region:your_aws_account_id:key/your_kms_key_id
sops --kms your:aws:kms:key:arn path/to/your/new/file.secret.sops.yml

### Encrypt using a GCP KMS key
### The value to the --gcp-kms argument should be an ID of the form
## projects/your_project_name/locations/your_region_or_the_word_global/keyRings/your_kms_keyring_name/cryptoKeys/your_kms_key_name
sops --gcp-kms path/to/your/gcp/kms path/to/your/new/file.secret.sops.yml

### Using VSCode as your EDITOR
### Note that -w is required to keep terminal open while you edit the file
EDITOR="code -w" sops --gcp-kms path/to/your/gcp/kms path/to/your/new/file.secret.sops.yml
```

In your editor, create a Kubernetes Secret Document. Below is an example of a kubernetes secret YAML.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: example-name
stringData:
  EXAMPLE_VAR: "example value"
```

With Kubernetes secrets, values in a `stringData` section do not need to be manually base64 encoded, Kubernetes will handle that for you. Values in the `stringData` section should be represented in plain text.

Save your file and exit your editor and sops should not output any errors. Your new `path/to/your/new/file.secret.sops.yml` should now have encrypted content and metadata about what KMS key was used to encrypt the data.

### Updating a Secret

Sops will decrypt the secret, open it in your editor, and encrypt the secret when your editor exits. While in your editor, add any additional plain text values you would like.

If the yaml was using a `data` section instead of a `stringData` section, you’ll need to base64 encode the value before adding it to the secret. That can be done with a command like this:

```bash
echo -n 'example_secret_value' | base64
```

After exiting your editor `sops` will re-encrypt all the data using the original KMS key you used to encrypt the original file. You can then commit that encrypted file into your source repo.

```bash
sops path/to/your/file.secret.sops.yml

## VSCode example
EDITOR="code -w" sops path/to/your/file.secret.sops.yml

## Atom editor example (-w for waiting to exit)
EDITOR="atom -w" sops path/to/your/file.secret.sops.yml
```

## External Secrets with AWS S3 or Google Cloud Storage
You can also store your secrets in either AWS S3 or Google Cloud Storage.
During deployment, secrets are copied from the object store into `Secret` manifests so
they are never committed to the repository. You edit and manage permissions for them
using the IAM permissions for your cloud provider.

When deploying, credentials for the cloud provider must be available.

Doing something like this:
```bash
mkdir mysecrets
echo -n 'asdfasdf' > mysecrets/password.txt
echo -n 'root' > mysecrets/username.txt
gsutil rsync mysecrets/ s3://exampleorg/production/mysecrets
echo 's3://exampleorg/production/mysecrets' > deploy/web-config.secret.external
echo 'EXTERNAL_SECRETS=(web-config)' >> app.config
```

Will generate a secret like this:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: web-config
data:
  username.txt: cm9vdCAtbgo=
  password.txt: YXNkZmFkc2YgLW4K
```
