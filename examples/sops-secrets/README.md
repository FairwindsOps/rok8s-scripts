## sops-secrets

**Note:** this example uses CircleCI v1

An example showing the decryption of a sops-encrypted file and deployment of the secret to Kubernetes.

The encrypted file can be created with a command similar to:

```
sops --encrypt --gcp-kms projects/example-project/locations/global/keyRings/example-keyring/cryptoKeys/example-key example.secret.yml
```

