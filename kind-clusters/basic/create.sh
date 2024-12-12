#!/bin/bash

# Go to root directory
DIR_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
cd "$DIR_ROOT" || exit 1

# Create the cluster
mkdir -p ~/mnt/kind/ 2> /dev/null
mkdir ./sensitive 2> /dev/null
kind delete cluster
kind create cluster --config ./general/kind-cluster.yaml

# Install ingress controller
echo "[NGINX CONTROLLER] Installing..."
sleep 5
kubectl apply --server-side -f ./general/nginx-controller.yaml  > /dev/null
echo "[NGINX CONTROLLER] Waiting for the deployment to be up"
sleep 10
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s > /dev/null
echo "[NGINX CONTROLLER] Installation completed"

# Install others
args="$@"
[[ "$args" =~ "grafana" ]] && ./grafana/install.sh
[[ "$args" =~ "kyverno" ]] && ./kyverno/install.sh
