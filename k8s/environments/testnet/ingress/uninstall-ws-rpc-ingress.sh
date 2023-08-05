#!/usr/bin/env bash

set -e

echo "Uninstalling myriad-node Websocket RPC Ingress"
cat <<EOF | kubectl delete -f -
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: myriad-node-websocket-rpc
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
    nginx.ingress.kubernetes.io/server-snippets: location / { proxy_http_version 1.1; proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection "upgrade"; }
    nginx.ingress.kubernetes.io/rewrite-target: /myriad/8f543a1c219f14d83c0faedefdd5be6e
spec:
  ingressClassName: nginx
  rules:
  - host: ws-rpc.testnet.myriad.social
    http:
      paths:
      - backend:
          service:
            name: myriad-node-websocket-rpc-external-service
            port:
              number: 443
        path: /
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - ws-rpc.testnet.myriad.social
    secretName: ws-rpc.testnet.myriad.social-letsencrypt-tls
EOF

echo "Uninstalling myriad-node Websocket RPC External Service"
cat <<EOF | kubectl delete -f -
kind: Service
apiVersion: v1
metadata:
  name: myriad-node-websocket-rpc-external-service
spec:
  type: ExternalName
  externalName: gateway.testnet.octopus.network
  ports:
  - port: 443
EOF
