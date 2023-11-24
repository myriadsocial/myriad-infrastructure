#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=myriad-social-mainnet
REPOSITORY_OWNER=myriadsocial
REPOSITORY_NAME=myriad-federated
REPOSITORY_FULL_NAME=${REPOSITORY_OWNER}/${REPOSITORY_NAME}

echo "Installing ${REPOSITORY_NAME}-secrets-store-provider"
cat <<EOF | kubectl apply -f -
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: ${REPOSITORY_NAME}-secrets-store-provider
spec:
  provider: gcp
  parameters:
    secrets: |
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/ENVIRONMENT/versions/latest
        path: ENVIRONMENT
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_FEDERATED_NAME/versions/latest
        path: WEB_FEDERATED_NAME
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_FEDERATED_URL/versions/latest
        path: WEB_FEDERATED_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_FEDERATED_SECRET/versions/latest
        path: WEB_FEDERATED_SECRET
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/SUPPORT_MAIL/versions/latest
        path: SUPPORT_MAIL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEBSITE_URL/versions/latest
        path: WEBSITE_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/NODE_RPC_WS_URL/versions/latest
        path: NODE_RPC_WS_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_FEDERATED_SENTRY_DSN/versions/latest
        path: WEB_FEDERATED_SENTRY_DSN
  secretObjects:
    - secretName: ${REPOSITORY_NAME}-secrets-store
      type: Opaque
      data: 
        - key: NEXT_PUBLIC_APP_ENVIRONMENT
          objectName: ENVIRONMENT
        - key: NEXT_PUBLIC_APP_NAME
          objectName: WEB_FEDERATED_NAME
        - key: NEXT_PUBLIC_APP_AUTH_URL
          objectName: WEB_FEDERATED_URL
        - key: APP_SECRET
          objectName: WEB_FEDERATED_SECRET
        - key: NEXT_PUBLIC_MYRIAD_SUPPORT_MAIL
          objectName: SUPPORT_MAIL
        - key: NEXT_PUBLIC_MYRIAD_WEBSITE_URL
          objectName: WEBSITE_URL
        - key: NEXT_PUBLIC_MYRIAD_RPC_URL
          objectName: NODE_RPC_WS_URL
        - key: NEXT_PUBLIC_SENTRY_DSN
          objectName: WEB_FEDERATED_SENTRY_DSN
EOF
