#!/bin/bash

# Go to root directory
DIR_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
cd "$DIR_ROOT" || exit 1

# Install Kyverno
# https://github.com/kyverno/kyverno/blob/release-1.13/charts/kyverno/values.yaml
echo "[KYVERNO] Installing..."
helm repo add kyverno https://kyverno.github.io/kyverno/  > /dev/null
helm repo update  > /dev/null
helm install kyverno kyverno/kyverno -n kyverno --create-namespace -f ./kyverno/values.yaml --wait  > /dev/null

echo "[KYVERNO] Installation completed"
