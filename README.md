## Getting started

### Install dependencies

Install the following packages:

- [Docker](https://taskfile.dev/installation/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Yq](https://mikefarah.gitbook.io/yq/v3.x)

### Initialize user's files

```shell
task init
```

List all the available tasks

```shell
task --list-all
```

### Create your first cluster

```shell
task brick:kind:install

kind get clusters
kubectl get pod -A
```

### Run your first brick

```shell
task brick:cert-manager:install
```

> **NOTE**
>
> Some bricks are going to populate the TODO.md file.
