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
  dhparam.pem: "LS0tLS1CRUdJTiBESCBQQVJBTUVURVJTLS0tLS0KTUlJQ0NBS0NBZ0VBby9hS2xtai96VXhhaWZHS3M4aUhST2JRL01HcWI4VTR1UDF6OE1TK1hmSzRNYWp0UGN4cQpOZDE3ai9rNHZLSndpdU1maE1HdElySUI1ays4cXhDeG54aGVES1dPNWlXLzZTR3QycEY0bjh1eEREbUNheHpLCllURlpQamNhdGtsY3ZRSy9EcFhtZUFMYzV4T0djb01NM3dYak5abFRmY3JScjlDYzVuVndiYlVIdk40SkxiSWwKdUk0M2s3OVo0dDVDZEo5MmxicWpoL2ZOUjJQVnNBUmNsQ3h3R2pqanF3ZUIxUkxCNXRqYkp4T3FiQkw2dElSNQpsazRoeE8vV3dvd3JwcjEzWUswVEoyQzExL3hBQVVsOGFZMFArd0tzTnpzZlMzU0xGNksxbVJ3a0g2WWlUK1VzClNMdzRHSk9oVXMxcVdWV291ODI3Uzgzd1dkcUhwTDVPT1NUSTI4R1FoRXpDL3pkSFJFUldRZmx1WjhMLy95K1kKL3NWWkV1bkhCSVpkdk1EVktla05CcDRXZTJaWTF1U3U1NUwzM2J1T0J1TlJBV2dmN0RQVEVxRzhhRDNqN2NrUApVUVNxVERjdTNIakkxT1dyOExKakk5THA3SjhZMUJKOUNSUjRDZ0hiRktRWWNKNWd6T0ZXa1ptazdUZkxlNzNGCjBlSGtqdi8xSFVKNGZBRHBVOHlYSjhTdUREdEVGWVFuSHA3bXhBM2J3MzJKWUFXeTc5RVg2cEpzTElmTlpQRTgKL2FjSUZhM0M2Wk4zUHZBZUZpQ0dMU1JaOGNtWm1oanNQWWRVZ1poUU43R2llUU96Q3grcERuTEF2WGRhdHZhagpSRkt6aTliaUxmeUd6UU4zMHdmWnc2S1JLSllSemFBaUJZcGNHWWNybUNVRDErTUxKUDA4UFNzQ0FRST0KLS0tLS1FTkQgREggUEFSQU1FVEVSUy0tLS0tCg=="
kind: Secret
metadata:
  name: ingress-nginx-lb-dhparam
  namespace: kube-system
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
EOF
