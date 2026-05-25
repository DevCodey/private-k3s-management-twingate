#!/usr/bin/env bash

set -euo pipefail

echo "=== Host Info ==="
hostname
whoami
ip -br a

echo
echo "=== Default Route ==="
ip route | grep default || true

echo
echo "=== SSH Listener ==="
sudo ss -tlnp | grep ':22' || echo "SSH is not listening on TCP 22"

echo
echo "=== SSH Service ==="
systemctl is-active ssh || true

echo
echo "=== K3s Service ==="
systemctl is-active k3s || true

echo
echo "=== Twingate Connector Health ==="
if command -v twingate-connectorctl >/dev/null 2>&1; then
  sudo twingate-connectorctl health || true
else
  echo "twingate-connectorctl not found"
fi

echo
echo "=== Twingate Services ==="
systemctl list-units --type=service | grep -i twingate || true

echo
echo "=== Kubernetes Nodes ==="
kubectl get nodes -o wide

echo
echo "=== Demo Pods ==="
kubectl get pods -n demo -o wide || true

echo
echo "=== Demo Service ==="
kubectl get svc -n demo -o wide || true

echo
echo "=== HTTP Test ==="
curl -s http://192.168.1.168:30080 | head -20 || echo "HTTP test failed"
