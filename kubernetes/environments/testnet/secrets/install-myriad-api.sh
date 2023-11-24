#!/usr/bin/env bash

set -e

GCP_PROJECT_ID=myriad-social-testnet
REPOSITORY_OWNER=myriadsocial
REPOSITORY_NAME=myriad-api
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
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_DNS/versions/latest
        path: API_DNS
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/SUBSTRATE_ADMIN_MNEMONIC/versions/latest
        path: SUBSTRATE_ADMIN_MNEMONIC
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/NEAR_ADMIN_MNEMONIC/versions/latest
        path: NEAR_ADMIN_MNEMONIC
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_JWT_TOKEN_SECRET_KEY/versions/latest
        path: API_JWT_TOKEN_SECRET_KEY
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_JWT_TOKEN_EXPIRES_IN/versions/latest
        path: API_JWT_TOKEN_EXPIRES_IN
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_JWT_REFRESH_TOKEN_SECRET_KEY/versions/latest
        path: API_JWT_REFRESH_TOKEN_SECRET_KEY
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_JWT_REFRESH_TOKEN_EXPIRES_IN/versions/latest
        path: API_JWT_REFRESH_TOKEN_EXPIRES_IN
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_MONGO_PROTOCOL/versions/latest
        path: API_MONGO_PROTOCOL
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_MONGO_HOST/versions/latest
        path: API_MONGO_HOST
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_MONGO_PORT/versions/latest
        path: API_MONGO_PORT
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_MONGO_USER/versions/latest
        path: API_MONGO_USER
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_MONGO_PASSWORD/versions/latest
        path: API_MONGO_PASSWORD
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_MONGO_DB/versions/latest
        path: API_MONGO_DB
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_REDIS_CONNECTOR/versions/latest
        path: API_REDIS_CONNECTOR
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_REDIS_HOST/versions/latest
        path: API_REDIS_HOST
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_REDIS_PORT/versions/latest
        path: API_REDIS_PORT
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_REDIS_PASSWORD/versions/latest
        path: API_REDIS_PASSWORD
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_SMTP_SERVER/versions/latest
        path: API_SMTP_SERVER
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_SMTP_PORT/versions/latest
        path: API_SMTP_PORT
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_SMTP_USERNAME/versions/latest
        path: API_SMTP_USERNAME
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_SMTP_PASSWORD/versions/latest
        path: API_SMTP_PASSWORD
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/FIREBASE_STORAGE_BUCKET/versions/latest
        path: FIREBASE_STORAGE_BUCKET
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_TWITTER_API_KEY/versions/latest
        path: API_TWITTER_API_KEY
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_COIN_MARKET_CAP_API_KEY/versions/latest
        path: API_COIN_MARKET_CAP_API_KEY
      - resourceName: projects/${GCP_PROJECT_ID}/secrets/API_SENTRY_DSN/versions/latest
        path: API_SENTRY_DSN
  secretObjects:
    - secretName: ${REPOSITORY_NAME}-secrets-store
      type: Opaque
      data: 
        - key: ENVIRONMENT
          objectName: ENVIRONMENT
        - key: DOMAIN
          objectName: API_DNS
        - key: MYRIAD_ADMIN_SUBSTRATE_MNEMONIC
          objectName: SUBSTRATE_ADMIN_MNEMONIC
        - key: MYRIAD_ADMIN_NEAR_MNEMONIC
          objectName: NEAR_ADMIN_MNEMONIC
        - key: JWT_TOKEN_SECRET_KEY
          objectName: API_JWT_TOKEN_SECRET_KEY
        - key: JWT_TOKEN_EXPIRES_IN
          objectName: API_JWT_TOKEN_EXPIRES_IN
        - key: JWT_REFRESH_TOKEN_SECRET_KEY
          objectName: API_JWT_REFRESH_TOKEN_SECRET_KEY
        - key: JWT_REFRESH_TOKEN_EXPIRES_IN
          objectName: API_JWT_REFRESH_TOKEN_EXPIRES_IN
        - key: MONGO_PROTOCOL
          objectName: API_MONGO_PROTOCOL
        - key: MONGO_HOST
          objectName: API_MONGO_HOST
        - key: MONGO_PORT
          objectName: API_MONGO_PORT
        - key: MONGO_USER
          objectName: API_MONGO_USER
        - key: MONGO_PASSWORD
          objectName: API_MONGO_PASSWORD
        - key: MONGO_DATABASE
          objectName: API_MONGO_DB
        - key: REDIS_CONNECTOR
          objectName: API_REDIS_CONNECTOR
        - key: REDIS_HOST
          objectName: API_REDIS_HOST
        - key: REDIS_PORT
          objectName: API_REDIS_PORT
        - key: REDIS_PASSWORD
          objectName: API_REDIS_PASSWORD
        - key: SMTP_SERVER
          objectName: API_SMTP_SERVER
        - key: SMTP_PORT
          objectName: API_SMTP_PORT
        - key: SMTP_USERNAME
          objectName: API_SMTP_USERNAME
        - key: SMTP_PASSWORD
          objectName: API_SMTP_PASSWORD
        - key: FIREBASE_STORAGE_BUCKET
          objectName: FIREBASE_STORAGE_BUCKET
        - key: TWITTER_API_KEY
          objectName: API_TWITTER_API_KEY
        - key: COIN_MARKET_CAP_API_KEY
          objectName: API_COIN_MARKET_CAP_API_KEY
        - key: SENTRY_DSN
          objectName: API_SENTRY_DSN
EOF
