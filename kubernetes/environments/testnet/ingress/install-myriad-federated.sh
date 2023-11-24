#!/usr/bin/env bash

set -e

REPOSITORY_NAME=myriad-federated
DNS=federated.testnet.myriad.social

echo "Installing ${REPOSITORY_NAME} Ingress"
cat <<EOF | kubectl apply -f -
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: ${REPOSITORY_NAME}
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    nginx.org/client-max-body-size: 100m
    nginx.ingress.kubernetes.io/proxy-body-size: 100m
    nginx.ingress.kubernetes.io/configuration-snippet: |
      more_set_headers "X-Frame-Options: Deny";
      more_set_headers "X-Content-Type-Options: nosniff";
      more_set_headers "X-XSS-Protection: 0";
      more_set_headers "Content-Security-Policy: connect-src 'self' blob: https: wss:; default-src 'self'; font-src 'self' https:; form-action 'self' https:; frame-src 'self' blob: https:; img-src 'self' blob: data: https:; manifest-src 'self'; media-src 'self' blob: https:; object-src 'self' blob: https:; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; script-src-attr 'self' 'unsafe-inline' 'unsafe-eval' https:; script-src-elem 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src-attr 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src-elem 'self' 'unsafe-inline' 'unsafe-eval' https:; worker-src 'self' blob:";
      more_set_headers "Permissions-Policy: accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()";
      more_set_headers "Referrer-Policy: strict-origin-when-cross-origin";
spec:
  ingressClassName: nginx
  rules:
  - host: ${DNS}
    http:
      paths:
      - backend:
          service:
            name: ${REPOSITORY_NAME}
            port:
              number: 80
        path: /
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - ${DNS}
    secretName: ${DNS}-letsencrypt-tls
EOF
