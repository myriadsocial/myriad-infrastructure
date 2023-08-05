#!/usr/bin/env bash

set -e

echo "Uninstalling Secrets Store GCP Provider"
kubectl delete -f https://raw.githubusercontent.com/GoogleCloudPlatform/secrets-store-csi-driver-provider-gcp/v1.1.0/deploy/provider-gcp-plugin.yaml

echo "Uninstalling Secrets Store CSI Driver"
helm uninstall csi-secrets-store --namespace kube-system
