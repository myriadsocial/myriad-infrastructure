#!/bin/bash

# download_files.sh - Script to download required files and generate random credentials

mkdir -p myriad-setup
cd myriad-setup

wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/docker/docker-compose.yml

# Generate random credentials
mongo_user=$(openssl rand -hex 8)
mongo_password=$(openssl rand -hex 16)
minio_root_user=$(openssl rand -hex 8)
minio_root_password=$(openssl rand -hex 16)

# Generate new parameters
app_secret=$(openssl rand -hex 32)
jwt_token_secret_key=$(openssl rand -hex 32)
jwt_refresh_token_secret_key=$(openssl rand -hex 32)

# Update docker-compose.yml with random credentials
sed -i "s/MONGO_INITDB_ROOT_USERNAME: .*/MONGO_INITDB_ROOT_USERNAME: $mongo_user/" docker-compose.yml
sed -i "s/MONGO_INITDB_ROOT_PASSWORD: .*/MONGO_INITDB_ROOT_PASSWORD: $mongo_password/" docker-compose.yml
sed -i "s/MINIO_ROOT_USER: .*/MINIO_ROOT_USER: $minio_root_user/" docker-compose.yml
sed -i "s/MINIO_ROOT_PASSWORD: .*/MINIO_ROOT_PASSWORD: $minio_root_password/" docker-compose.yml

# Update MongoDB connection strings
sed -i "s/MONGO_USER=.*/MONGO_USER=$mongo_user/" docker-compose.yml
sed -i "s/MONGO_PASSWORD=.*/MONGO_PASSWORD=$mongo_password/" docker-compose.yml
sed -i "s|MONGO_URL=.*|MONGO_URL=mongodb://$mongo_user:$mongo_password@myriad-mongo:27017/myriad?authSource=admin|" docker-compose.yml

# Update new parameters
sed -i "s/APP_SECRET=.*/APP_SECRET=$app_secret/" docker-compose.yml
sed -i "s/JWT_TOKEN_SECRET_KEY=.*/JWT_TOKEN_SECRET_KEY=$jwt_token_secret_key/" docker-compose.yml
sed -i "s/JWT_REFRESH_TOKEN_SECRET_KEY=.*/JWT_REFRESH_TOKEN_SECRET_KEY=$jwt_refresh_token_secret_key/" docker-compose.yml

mkdir -p mongodb/dump/myriad
cd mongodb/dump/myriad
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/currencies.bson
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/currencies.metadata.json
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/networks.bson
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/networks.metadata.json
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/servers.bson
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/servers.metadata.json
cd ../../..

echo "Files downloaded and credentials updated successfully."
echo "MongoDB user: $mongo_user"
echo "MongoDB password: $mongo_password"
echo "MinIO root user: $minio_root_user"
echo "MinIO root password: $minio_root_password"
echo "APP_SECRET: $app_secret"
echo "JWT_TOKEN_SECRET_KEY: $jwt_token_secret_key"
echo "JWT_REFRESH_TOKEN_SECRET_KEY: $jwt_refresh_token_secret_key"
echo "Please make sure to update any other necessary configuration files with these new credentials and parameters."