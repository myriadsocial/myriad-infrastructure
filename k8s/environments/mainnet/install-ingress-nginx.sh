#!/usr/bin/env bash

set -e

echo "Installing ingress-nginx-lb-dhparam Secret"
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  dhparam.pem: "LS0tLS1CRUdJTiBESCBQQVJBTUVURVJTLS0tLS0KTUlJQ0NBS0NBZ0VBOHNFM2w3bnlobGFQNk55OElHMGl4QkZZQmRScTlyR2FJL2pXbTFXS3U2cm1uSGFlSkhMaApYdXZ3TERnVTRRcVhGQjRHUGVROEJtcnArMkFHTG4zSmdiY2R3ak40QnllVFQvM1dQVUZYNnhQOFlQWDZIM0ZjCndEZEZRRjhNaUZJMTJEV1N2SkpDdUZsWDlIRFVDbTlnT1daWWFNTnhmN2I0OTNVeTh3eVM0SVZHZjdmckJNZEgKUkozOHZ1MjVwY05nVTFKQStMRXQ3eDF0OElIMVVRNnpRcmpIZVdIeG1nYnJjbG9Kem9LOW1rSVB6NUNEclRFSApMVlNuZUtidXhkTGtKNXlIMzhYVE9EMjRoRHFqMzU1R1ZNb3Rjb2pxOFNJRWRkWGNLVEFxMHMzdE42KzlUZ1Y4CmNscGwyTyswbDU1SjhwTXl4Vk4wTnQzQnZDcXdjamlFR0VwejBpZnVwY2lyanVwWXRzTkVEaE1ScWFMZFd2RXIKSVBJeUp5VnphaWhLZ2tpMmw1SG12anRvbnlYTnNDSHEwdEE1WUVxSCtxYnhtVTNSUCtISFg3T2ZFWUxsQjBmNgpQZDYyOHVVWlB1bFJJWWc4WU9aOThCaHo4ZHB6Yko4cWhuUjNoK2JQR3JPYmh4dDhPc2pRbnpxQmhpNkxGT3lvCkxmNE9ldHhnVUtOckNGRTVST2Q4MUZBbmY5RkpQK0JSaGhlL1NjMXJDSC9zd1VyNloxL2ZFWktoYzByQXpJQmQKOVN5MDFBSXVleVF0MnBuUVoxVWpINkM1ZHdObFRzSzNEekh0Tncyb3BEekpIRTNlbWhVV1ozQ1EzYzJnaUFiegpUYy9DeTZDR1l1Rjhtejc0WmFSRW0rSHk5enJ1ZEpUMEZRYkphbUFlajZ0OHorNENLRlBpdHlNQ0FRST0KLS0tLS1FTkQgREggUEFSQU1FVEVSUy0tLS0tCg=="
kind: Secret
metadata:
  name: ingress-nginx-lb-dhparam
  namespace: kube-system
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
EOF

echo "Installing ingress-nginx-custom-header ConfigMap"
cat <<EOF | kubectl apply -f -
apiVersion: v1
data: 
  X-Frame-Options: "DENY" 
  X-Content-Type-Options: "nosniff"
  X-XSS-Protection: "0"
  Content-Security-Policy: "connect-src 'self' blob: https: wss:; default-src 'self'; font-src 'self' https:; form-action 'self' https:; frame-src 'self' https:; img-src 'self' blob: data: https:; manifest-src 'self'; media-src 'self' blob: https:; object-src 'none'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; script-src-attr 'self' 'unsafe-inline' 'unsafe-eval' https:; script-src-elem 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src-attr 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src-elem 'self' 'unsafe-inline' 'unsafe-eval' https:; worker-src 'self' blob:"
  Permissions-Policy: "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()"
  Referrer-Policy: "strict-origin-when-cross-origin"
kind: ConfigMap
metadata:
  name: ingress-nginx-custom-header
  namespace: kube-system
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
EOF

echo "Initializing ingress-nginx"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

echo "Installing ingress-nginx"
helm upgrade ingress-nginx ingress-nginx/ingress-nginx \
  --install \
  --namespace kube-system \
  --version 4.2.3 \
  --set controller.config.keep-alive=10 \
  --set controller.config.enable-ocsp="true" \
  --set controller.config.hsts-preload="true" \
  --set controller.config.force-ssl-redirect="true" \
  --set controller.config.ssl-protocols="TLSv1.3" \
  --set controller.config.ssl-ciphers="EECDH+AESGCM:EDH+AESGCM" \
  --set controller.config.ssl-dh-param=ingress-nginx-lb-dhparam \
  --set controller.config.add-headers=ingress-nginx-custom-header \
  --set controller.config.hide-headers="X-Powered-By"
