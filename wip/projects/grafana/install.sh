#!/bin/bash

# Go to root directory
DIR_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$DIR_ROOT" || exit 1

ADMIN_USER=admin
ADMIN_PASSWORD=password

echo "[GRAFANA] Installing prometheus stack..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts > /dev/null
helm repo update > /dev/null
helm install prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace --wait > /dev/null

echo "[GRAFANA] Installing operator..."
# https://grafana.github.io/grafana-operator/docs/installation/helm/
helm upgrade -i grafana-operator oci://ghcr.io/grafana/helm-charts/grafana-operator --namespace monitoring --create-namespace --wait --version v5.6.0 &> /dev/null

echo "[GRAFANA] Create resources"
kubectl create secret generic grafana-admin-credentials --namespace monitoring --from-literal=GF_SECURITY_ADMIN_USER=$ADMIN_USER --from-literal=GF_SECURITY_ADMIN_PASSWORD=$ADMIN_PASSWORD
kubectl apply --server-side --namespace monitoring -f ./resources.yaml

echo "[GRAFANA] Updating hosts file..."
grep -v "grafana.local" /etc/hosts | sudo tee /etc/hosts > /dev/null
echo -e "127.0.0.1\tgrafana.local" | sudo tee -a /etc/hosts > /dev/null

echo "[GRAFANA] Store admin credentials"
cat << EOF > sensitive/grafana-admin.yaml
admin:
  user: $ADMIN_USER
  password: $ADMIN_PASSWORD
EOF

echo "[GRAFANA] Installation completed"