#!/bin/bash

# setup_minio.sh - Script to set up MinIO

# Check if docker-compose.yml exists
if [ ! -f myriad-setup/docker-compose.yml ]; then
    echo "Error: docker-compose.yml not found in myriad-setup directory. Please run the download_files.sh script first."
    exit 1
fi

# Read MinIO root user and password from docker-compose.yml
minio_root_user=$(grep MINIO_ROOT_USER myriad-setup/docker-compose.yml | awk '{print $2}')
minio_root_password=$(grep MINIO_ROOT_PASSWORD myriad-setup/docker-compose.yml | awk '{print $2}')

if [ -z "$minio_root_user" ] || [ -z "$minio_root_password" ]; then
    echo "Error: Unable to read MinIO root user or password from docker-compose.yml"
    exit 1
fi

# Start MinIO container
docker compose -f myriad-setup/docker-compose.yml up -d minio

# Wait for MinIO to start
echo "Waiting for MinIO to start..."
sleep 10

# Create access key and secret key
echo "Creating MinIO access key and secret key..."
docker compose -f myriad-setup/docker-compose.yml exec -T minio mc alias set myminio http://localhost:9000 "$minio_root_user" "$minio_root_password"
access_key=$(openssl rand -hex 8)
secret_key=$(openssl rand -hex 16)
docker compose -f myriad-setup/docker-compose.yml exec -T minio mc admin user add myminio "$access_key" "$secret_key"

if [ $? -ne 0 ]; then
    echo "Error: Failed to create MinIO user. Please check MinIO logs and try again."
    exit 1
fi

# Update docker-compose.yml with new MinIO keys
echo "Updating docker-compose.yml with new MinIO keys..."
sed -i "s/MINIO_ROOT_USER: .*/MINIO_ROOT_USER: $access_key/" myriad-setup/docker-compose.yml
sed -i "s/MINIO_ROOT_PASSWORD: .*/MINIO_ROOT_PASSWORD: $secret_key/" myriad-setup/docker-compose.yml

echo "MinIO setup complete. New access key: $access_key, new secret key: $secret_key"
echo "Please restart your services to apply the new MinIO credentials."