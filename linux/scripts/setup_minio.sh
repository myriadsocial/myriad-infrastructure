#!/bin/bash

# setup_minio.sh - Script to set up MinIO

if [ ! -f docker-compose.yml ]; then
    echo "Error: docker-compose.yml not found. Please run the download_files.sh script first."
    exit 1
fi

# Start MinIO container
docker compose -f myriad_setup_scripts/myriad-setup/docker-compose.yml up -d minio

# Wait for MinIO to start
sleep 10

# Create access key and secret key
access_key=$(docker compose -f myriad_setup_scripts/myriad-setup/docker-compose.yml exec -T minio mc admin user add local accesskey secretkey)
secret_key=$(docker compose -f myriad_setup_scripts/myriad-setup/docker-compose.yml exec -T minio mc admin user info local accesskey | grep SecretKey | awk '{print $2}')

# Update docker-compose.yml with MinIO keys
sed -i "s/MINIO_ACCESS_KEY=.*/MINIO_ACCESS_KEY=$access_key/" docker-compose.yml
sed -i "s/MINIO_SECRET_KEY=.*/MINIO_SECRET_KEY=$secret_key/" docker-compose.yml
