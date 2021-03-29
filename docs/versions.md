# Versioning

## Upgrading from v10 to v11

The v11 series of rok8s-scripts will include [Helm 3](https://helm.sh/blog/helm-3-released/). This will require your cluster to be running Helm3 for it to work.

*WARNING* If you deploy your application with Helm3 and it has already been deployed with Helm 2, you may have issues!!! Please [migrate to Helm 3](https://helm.sh/docs/topics/v2_v3_migration/) before using Rok8s-Scripts v11+!!

## Versioning v8.0.0 and beyond

Rok8s-scripts contains a number of dependencies that have various ways of versioning themselves. Most notably, Helm tends to break backward compatibility with every minor release. We have decided that post v8 of rok8s-scripts, we will update our versions according to the version change of the underlying tool. For example, if Helm changes from `2.13.0` to `2.14.0`, we will change the version of rok8s scripts by one minor version. This will be clearly mentioned in the release notes. This means that a minor version of rok8s-scripts could introduce breaking changes to the CI/CD pipelines that are using it.

Please note that we will still commit to any patch version releases being backward-compatible. We will never release a patch version that upgrades an underlying tool beyond a patch version, and we will not release any patch versions of rok8s-scripts that introduce a breaking change.

Here is a set of guidelines to follow when deciding what version of ci-images (and thus rok8s-scripts) to use:

#### You are very risk-averse

You want rok8s-scripts to be stable, and just keep working until you decide to upgrade.

In this scenario, you should pin to a minor version of rok8s-scripts such as `v11.7-alpine`.

#### You like to live dangerously

You are okay with your pipeline breaking occasionally and having to upgrade things as they break.

In this case, go ahead and pin to a major version such as `v11-alpine`.
