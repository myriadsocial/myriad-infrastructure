#!/usr/bin/env bash

set -e

REPOSITORY_NAME=myriad-node
DNS=ws-rpc.myriad.social

echo "Installing ${REPOSITORY_NAME} Websocket RPC External Service"
cat <<EOF | kubectl apply -f -
kind: Service
apiVersion: v1
metadata:
  name: ${REPOSITORY_NAME}-websocket-rpc-external-service
spec:
  type: ExternalName
  externalName: gateway.mainnet.octopus.network
  ports:
  - port: 443
EOF

echo "Installing ${REPOSITORY_NAME} Websocket RPC Ingress"
cat <<EOF | kubectl apply -f -
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: ${REPOSITORY_NAME}-websocket-rpc
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/upstream-vhost: gateway.mainnet.octopus.network
    nginx.ingress.kubernetes.io/rewrite-target: /myriad/a4cb0a6e30ff5233a3567eb4e8cb71e0
    nginx.ingress.kubernetes.io/server-snippet: |
      proxy_ssl_name gateway.mainnet.octopus.network;
      proxy_ssl_server_name on;
spec:
  ingressClassName: nginx
  rules:
  - host: ${DNS}
    http:
      paths:
      - backend:
          service:
            name: ${REPOSITORY_NAME}-websocket-rpc-external-service
            port:
              number: 443
        path: /
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - ${DNS}
    secretName: ${DNS}-letsencrypt-tls
EOF
