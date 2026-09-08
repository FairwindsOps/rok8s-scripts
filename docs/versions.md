---
meta:
  - name: description
    content: "Fairwinds rok8s Scripts | Versioning"
---
# Versioning

## Upgrading from v16 to v17

v17 upgrades kind from `0.17.0` to `0.33.0` and changes the default kind node image from Kubernetes `1.24.6` to `1.37.0`. If you use `kubernetes_e2e_tests` / `e2e_start_kind_cluster`, this is a breaking change.

* Pin `kind_node_image` by digest from the **same** kind release. Images from older kind releases are not guaranteed to work, and `kind load` requires kind `0.27.0+` for containerd 2.x node images.
* Kubernetes `1.36+` uses kubeadm `v1beta4`. The default `kind_config` includes both `v1beta3` and `v1beta4` patches. If you pass a custom `kind_config` with `kubeadmConfigPatches`, version those patches: `v1beta3` for Kubernetes `<1.36`, `v1beta4` for `1.36+`. `extraArgs` is a list of `{name, value}` in v1beta4, not a map.
* Default Kubernetes `1.37` requires cgroup v2 on the host (CircleCI remote Docker). If you must stay on cgroup v1, pin an older node image such as `kindest/node:v1.34.11` from the kind `0.33.0` release notes.
* Docker `20.10.0+` is required. Multi-control-plane clusters now use Envoy instead of HAProxy.

Kind `0.33.0` node images (always include the digest):

* `v1.37.0`: `kindest/node:v1.37.0@sha256:a1ed56cfb0e7b93589bdf97c8cd566405a265939e3620fc4f5de89adff580ae5`
* `v1.36.4`: `kindest/node:v1.36.4@sha256:099e049362a1526b2db71494e1947aae99bd16290d7c895f2b7ea312e3cbfaed`
* `v1.35.8`: `kindest/node:v1.35.8@sha256:07b2536e30b803ed61d1677a79df6115f798ce64c80f9e22f6ed45afd09323c0`
* `v1.34.11`: `kindest/node:v1.34.11@sha256:44e222ee2132dab25ff87301682f89eb82c7880ea3a1bf543bfe9708fd08d67d`

## Upgrading from v10 to v11

The v11 series of rok8s-scripts will include [Helm 3](https://helm.sh/blog/helm-3-released/). This will require your cluster to be running Helm3 for it to work.

*WARNING* If you deploy your application with Helm3 and it has already been deployed with Helm 2, you may have issues!!! Please [migrate to Helm 3](https://helm.sh/docs/topics/v2_v3_migration/) before using Rok8s-Scripts v11+!!

## Versioning v8.0.0 and beyond

Rok8s-scripts contains a number of dependencies that have various ways of versioning themselves. Most notably, Helm tends to break backward compatibility with every minor release. We have decided that post v8 of rok8s-scripts, we will update our versions according to the version change of the underlying tool. For example, if Helm changes from `2.13.0` to `2.14.0`, we will change the version of rok8s scripts by one minor version. This will be clearly mentioned in the release notes. This means that a minor version of rok8s-scripts could introduce breaking changes to the CI/CD pipelines that are using it.

Please note that we will still commit to any patch version releases being backward-compatible. We will never release a patch version that upgrades an underlying tool beyond a patch version, and we will not release any patch versions of rok8s-scripts that introduce a breaking change.

Here is a set of guidelines to follow when deciding what version of ci-images (and thus rok8s-scripts) to use:

#### You are very risk-averse

You want rok8s-scripts to be stable, and just keep working until you decide to upgrade.

In this scenario, you should pin to a minor version of rok8s-scripts such as `v11.8-alpine`.

#### You like to live dangerously

You are okay with your pipeline breaking occasionally and having to upgrade things as they break.

In this case, go ahead and pin to a major version such as `v11-alpine`.
