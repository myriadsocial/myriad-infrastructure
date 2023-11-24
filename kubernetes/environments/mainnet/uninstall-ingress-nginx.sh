#!/usr/bin/env bash

set -e

echo "Uninstalling ingress-nginx"
helm uninstall ingress-nginx --namespace kube-system

echo "Uninstalling ingress-nginx-custom-header ConfigMap"
cat <<EOF | kubectl delete -f -
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

echo "Uninstalling ingress-nginx-lb-dhparam secret"
cat <<EOF | kubectl delete -f -
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
