#!/usr/bin/env bash

set -e

gcloud config set account xxx@blocksphere.id
gcloud config set project myriad-social-mainnet
gcloud config set compute/region asia-southeast1
gcloud config set compute/zone asia-southeast1-b
gcloud config list
gcloud container clusters get-credentials --internal-ip myriad-mainnet --project myriad-social-mainnet --region asia-southeast1
gcloud compute ssh myriad-mainnet-bastion --quiet --tunnel-through-iap --ssh-flag="-4 -L 8888:127.0.0.1:8888 -N -q -f" --project myriad-social-mainnet --zone asia-southeast1-b

# echo "Initializing user as a cluster-admin"
# HTTPS_PROXY=127.0.0.1:8888 kubectl create clusterrolebinding cluster-admin-binding \
#   --clusterrole cluster-admin \
#   --user $(gcloud config get-value account)
