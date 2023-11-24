#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=myriad-social-testnet
REPOSITORY_OWNER=myriadsocial
REPOSITORY_NAME=myriad-web
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
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_APP_NAME/versions/latest
        path: WEB_APP_NAME
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_APP_URL/versions/latest
        path: WEB_APP_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_APP_SECRET/versions/latest
        path: WEB_APP_SECRET
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/SUPPORT_MAIL/versions/latest
        path: SUPPORT_MAIL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEBSITE_URL/versions/latest
        path: WEBSITE_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/NODE_RPC_WS_URL/versions/latest
        path: NODE_RPC_WS_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_URL/versions/latest
        path: API_URL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/NEAR_TIPPING_CONTRACT_ADDRESS/versions/latest
        path: NEAR_TIPPING_CONTRACT_ADDRESS
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/FIREBASE_PROJECT_ID/versions/latest
        path: FIREBASE_PROJECT_ID
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/FIREBASE_API_KEY/versions/latest
        path: FIREBASE_API_KEY
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/FIREBASE_MESSAGING_SENDER_ID/versions/latest
        path: FIREBASE_MESSAGING_SENDER_ID
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_APP_FIREBASE_APP_ID/versions/latest
        path: WEB_APP_FIREBASE_APP_ID
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_APP_FIREBASE_MEASUREMENT_ID/versions/latest
        path: WEB_APP_FIREBASE_MEASUREMENT_ID
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/FIREBASE_STORAGE_BUCKET/versions/latest
        path: FIREBASE_STORAGE_BUCKET
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/WEB_APP_SENTRY_DSN/versions/latest
        path: WEB_APP_SENTRY_DSN
  secretObjects:
    - secretName: ${REPOSITORY_NAME}-secrets-store
      type: Opaque
      data: 
        - key: NEXT_PUBLIC_APP_ENVIRONMENT
          objectName: ENVIRONMENT
        - key: NEXT_PUBLIC_APP_NAME
          objectName: WEB_APP_NAME
        - key: NEXTAUTH_URL
          objectName: WEB_APP_URL
        - key: APP_SECRET
          objectName: WEB_APP_SECRET
        - key: NEXT_PUBLIC_MYRIAD_SUPPORT_MAIL
          objectName: SUPPORT_MAIL
        - key: NEXT_PUBLIC_MYRIAD_WEBSITE_URL
          objectName: WEBSITE_URL
        - key: NEXT_PUBLIC_MYRIAD_RPC_URL
          objectName: NODE_RPC_WS_URL
        - key: NEXT_PUBLIC_MYRIAD_API_URL
          objectName: API_URL
        - key: NEAR_TIPPING_CONTRACT_ID
          objectName: NEAR_TIPPING_CONTRACT_ADDRESS
        - key: NEXT_PUBLIC_FIREBASE_PROJECT_ID
          objectName: FIREBASE_PROJECT_ID
        - key: NEXT_PUBLIC_FIREBASE_API_KEY
          objectName: FIREBASE_API_KEY
        - key: NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID
          objectName: FIREBASE_MESSAGING_SENDER_ID
        - key: NEXT_PUBLIC_FIREBASE_APP_ID
          objectName: WEB_APP_FIREBASE_APP_ID
        - key: NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID
          objectName: WEB_APP_FIREBASE_MEASUREMENT_ID
        - key: NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET
          objectName: FIREBASE_STORAGE_BUCKET
        - key: NEXT_PUBLIC_SENTRY_DSN
          objectName: WEB_APP_SENTRY_DSN
EOF
