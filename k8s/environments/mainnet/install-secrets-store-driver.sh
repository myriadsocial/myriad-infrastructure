#!/usr/bin/env bash

set -e

echo "Initializing Secrets Store CSI Driver"
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm repo update

echo "Installing Secrets Store CSI Driver"
helm upgrade csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver \
    --install \
    --namespace kube-system \
    --version 1.2.4 \
    --set syncSecret.enabled=true

echo "Installing Secrets Store GCP Provider"
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/secrets-store-csi-driver-provider-gcp/v1.1.0/deploy/provider-gcp-plugin.yaml
