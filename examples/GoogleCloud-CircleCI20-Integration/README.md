# GCP and CircleCI 2.0 Integration

### Environment Variables

In order to provide your application with all of the environment variables that
you require, you will want to create a configMap for those values that may be
stored in plaintext, and Kubernetes Secrets for Environment Variables that
should be encoded and encrypted at rest.

After determining the plaintext environment variables, you then add them as
items in `deploy/<appname>.deployment.yml`, under the section
`spec.template.spec.env`.

Likewise, for Secrets, create similar entries in
`deploy/<appname>.deployment.yml`, however the you will use `secretKeyRef` as
the `valueFrom`.

For each of the env vars, you will create an entry in the
`deploy/<environment>/<appname>.configmap.yml` or `appname.secrets.yml` for
secrets, under the `data` section.  An example plaintext secrets file is
included for illustration purposes in the development directory.  The values
that you provide should for the secrets should be base64-encoded.  You may do
this like so:

```
echo -n 'verySecret' | base64
```

***NOTE:*** it is not intended to check the `appname.secrets.yml` into source-
control.  These values are only *encoded*, not *encrypted*, and it is trivial to
decode them into plaintext.  You should probably include these files in your
`.gitignore`

### Encrypting Secrets

For encrypting our secrets, we will use
[`sops`](https://github.com/mozilla/sops) from Mozilla.

After storing your secret in the GCP KMS, you will run the sops to encrypt your
`appname.secret.yml`, creating `appname.secret.sops.yml`.  From the deploy dir,
for example, you would run:

```
sops --encrypt --input-type yml --gcp-kms projects/company-dev/locations/global/keyRings/company_gke_secrets/cryptoKeys/development development/appname.secret.yml > development/appname.secret.sops.yml
```

To decrypt, you would run:

```
sops --decrypt --input-type yml --gcp-kms projects/company-dev/locations/global/keyRings/company_gke_secrets/cryptoKeys/development development/appname.secret.sops.yml > development/appname.secret.yml
```

As you see from the `sops`-encrypted file, the value at
`sops.kms.gcp_kms.resource_id` specifies the key that was used to encrypt, so
you will use that same path to decrypt it.
