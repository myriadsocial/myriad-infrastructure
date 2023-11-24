#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=myriad-social-testnet
REPOSITORY_OWNER=myriadsocial
REPOSITORY_NAME=myriad-web
REPOSITORY_FULL_NAME=${REPOSITORY_OWNER}/${REPOSITORY_NAME}
DOCKER_TAG=dd4d02702620a58964d5273831005f886fd1b880

echo "Installing ${REPOSITORY_NAME}"
helm repo add myriadsocial https://charts.myriad.social
helm repo update
helm upgrade myriad-web myriadsocial/myriad-web \
  --install \
  --set-string image.tag=${DOCKER_TAG} \
  --set-string serviceAccount.name=${REPOSITORY_NAME} \
  --set-string serviceAccount.annotations."iam\.gke\.io/gcp-service-account"=${REPOSITORY_NAME}@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
  --set config.secretsStore.enabled=true \
  --set-string config.secretsStore.providerClass=${REPOSITORY_NAME}-secrets-store-provider \
  --set-string config.secretsStore.name=${REPOSITORY_NAME}-secrets-store \
  --set-string nodeSelector.node_pool=general \
  --set-string nodeSelector.'iam\.gke\.io/gke-metadata-server-enabled'='true'
kubectl rollout status deployment/myriad-web
