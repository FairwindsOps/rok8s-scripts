# Managing Kubernetes Secrets Securely
There are multiple ways to securely manage Kubernetes Secrets with rok8s-scripts. With support for AWS Secrets Manager, Sops encrypted secrets, and fetching secrets from external sources like AWS S3 or Google Cloud Storage, there should be at least one option that works well for you.

## External Secrets Managers
It is also possible to retrieve individual key/value pairs from an external secrets manager. Supported secret stores are:

* AWS Secrets Manager - specify a list of AWS secret names to retrieve by setting `AWS_SECRETS`.

There are two ways to use this:
* `. get-secrets` - this will allow you to use the variables as environment variables
* As part of `k8s-deploy-secrets` when you set `EXTERNAL_SECRETS_K8S_NAME`.  This will create a secret in the k8s cluster with all of the secrets from the secret store that you listed.

There is an example [here](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/external-secrets-manager).

## Encrypted Secrets With Sops
Sops and rok8s-scripts can provide a powerful solution to encrypted secret management. This enables you to keep your secrets in source control and track changes to those secrets along with the rest of your Kubernetes configuration. All of this is powered with cloud based KMS from either AWS or GCP. To access secrets, users need access to both your Git repository and appropriate IAM credentials for KMS.

Using an [AWS KMS](https://aws.amazon.com/kms/) ARN or [Google KMS](https://cloud.google.com/kms/) ID, `Secret` manifests are encrypted in the source code and decrypted at deployment time.

Whenever encrypting data, `sops` requires credentials for the appropriate
cloud provider (GCP or AWS). You can read more about `sops` usage [here](https://github.com/mozilla/sops#usage). Full examples of sops usage with rok8s-scripts can be
[found here](https://github.com/FairwindsOps/rok8s-scripts/tree/master/examples/sops-secrets).

The examples below will use GCP KMS, but the process is very similar when using AWS KMS.

### Setting up GCloud SDK and SOPS
You may need to run the following command to assure Sops can get to your KMS keys in Google Cloud. If you are experiencing “authorization errors” when trying to follow the create/update steps below then you may need to run this.

```bash
gcloud auth applicaton-default login
```

### Creating a New Secret

Sops, by default, will open a file in memory to create and encrypt. If you want to encrypt a new file you can run the commands below. Note that if you want to override your terminals default editor (usually set to `vi`) then you can provide an `$EDITOR` environment variable. Included is an example of using sops with vscode (note not all editors are supported).


```bash
sops --gcp-kms path/to/your/gcp/kms path/to/your/file.yml

### With VSCode as EDITOR
### Note that -w is required to keep terminal open while you edit the file
EDITOR="code -w" sops --gcp-kms path/to/your/gcp/kms path/to/your/file.yml
```

Once your editor opens up you can create a Kubernetes Secret Document. Below is an example of a kubernetes secret YAML.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: example-name
stringData:
  EXAMPLE_VAR: "example value"
```

With Kubernetes secrets, values in a `stringData` section do not need to be manually base64 encoded, Kubernetes will handle that for you. Instead, the value should be represented in plain text.

Save your file and exit your editor and your terminal should not have any errors. Your new `path/to/your/file.yml` should now have encrypted content and metadata about what KMS key was used to encrypt the data.

### Updating a Secret

To update an existing secret encrypted with Sops, we first need to decrypt it.

```bash
sops path/to/your/file.yml

## VSCode example
EDITOR="code -w" sops path/to/your/file.yml

## Atom editor example (-w for waiting to exit)
EDITOR="atom -w" sops path/to/your/file.yml
```

At this point you can add any additional plain text values you would like in the editor.

If the encrypted yaml was using a `data` section instead of a `stringData` section, you’ll need to base64 encode the value before adding it to the secret. That can be done with a command like this:

```bash
echo -n 'example_secret_value' | base64
```

After exiting your editor `sops` will re-encrypt all the data using the original KMS key you used to encrypt the original file. You can then commit that encrypted file back into your source repo.

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
