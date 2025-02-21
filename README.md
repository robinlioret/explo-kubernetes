# explo-kubernetes

An exploration of some kubernetes tools and features

## Prerequisite

First of all, you'll need [Justfile](https://taskfile.dev/installation/) to be installed.

Then, you'll need the following:

- [Docker](https://taskfile.dev/installation/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)

Once all those tools are installed, you can move on and test.

### HTTPS

> HTTPS, here, is a comfort feature that make the tests of the GUIs and CLIs more realistic (removing the warning from the browser)

Since we are testing locally, we are not going to generate a certificate from a real CA. We'll mock this feature on the ingress.

First, generate the certificate with `task create-self-signed-ca-certificate`, it will be stored in the `certificates` directory.

Then, add it to your system:

```shell
sudo cp ./assets/certificates/ca.crt /usr/local/share/ca-certificates/sandbox.local.crt
sudo update-ca-certificates
```

> **Note** you'll need update-ca-certificates to be installed on your machine.

Finally, add the certificate to your browser. The actual actions depends on your browser. Please review its documentation.

## Usage

You can list the possible actions with `task --list-all`

### Create a kind cluster using a preset

Kind cluster configurations are stored in the directory `bricks/kind/configs`. There are named as follow:

`c<# of control-plane>w<# of workers>[-<propertys>...].yaml`

Per example:
- `c1w0.yaml`
- `c1w3-exposed.yaml`

The properties are arbitrary:

- `exposed` means that some ports are exposed on the nodes.

To create a cluster, simply call the task :

```shell
# Simple c1w0 cluster named sandbox
task kind:create

# c1w3 cluster with http ports exposed, named "my-test"
KIND_CLUSTER_CONFIG="c1w3-exposed" KIND_CLUSTER_NAME="my-test" task kind:create
```

### Run the standalone grafana brick

Run `task grafana:standalone` (it will take a while). You may need to enter your sudo password to add `grafana.sandbox.local` to your hosts file (or do it manually)

Once done, open https://grafana.sandbox.local (user: admin, password: admin)

Et voilà!

### Adding feature to the standalone brick

Each bricks deliver at least two tasks: 

- `standalone`: recreate a cluster before deploying the dependencies
- `deploy`: deploy only the resources of the brick

Per example, add tekton to the environment: `task tekton:deploy` then open https://tekton.sandbox.local.

## Cleaning up

Once you finished your tests.

### Tear down the cluster

Use `task tear-down`.

If you're not planning to redo some tests, perform the following actions:

### Delete the CA certificate

- From your browser (see the browser documentation)
- From your system

```shell
sudo rm /usr/local/share/ca-certificates/sandbox.local.crt
sudo update-ca-certificates --fresh
```

### Restore your /etc/hosts file

```shell
cp /etc/hosts ~/hosts.${date +%Y%m%d%H%M%S}.bak
grep -v "sandbox.local" /etc/hosts | sudo tee /etc/hosts
```

## Issues

- Pod failing because of Too Many Opened files: https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files

## Backlog

- [ ] Cilium
- [ ] Tetragon
- [ ] Istio
- [ ] Grafana
- [ ] Terraform Cloud
- [ ] ArgoCD
- [ ] Crossplane
- [ ] Kyverno
- [ ] NginxController
- [ ] CertManager
- [ ] Tekton
