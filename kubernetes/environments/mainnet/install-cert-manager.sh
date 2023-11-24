#!/usr/bin/env bash

set -e

echo "Initializing cert-manager"
helm repo add jetstack https://charts.jetstack.io
helm repo update

echo "Installing cert-manager"
helm upgrade cert-manager jetstack/cert-manager \
  --install \
  --namespace kube-system \
  --version v1.9.1 \
  --set installCRDs=true

echo "Installing letsencrypt ClusterIssuer"
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
  namespace: kube-system
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: devops@myriad.social
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
