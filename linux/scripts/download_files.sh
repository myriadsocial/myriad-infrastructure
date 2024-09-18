#!/bin/bash

# download_files.sh - Script to download required files

mkdir -p myriad-setup
cd myriad-setup

wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/docker/docker-compose.yml

# Generate random credentials
mongo_user=$(openssl rand -hex 8)
mongo_password=$(openssl rand -hex 16)
minio_root_user=$(openssl rand -hex 8)
minio_root_password=$(openssl rand -hex 16)

# Update docker-compose.yml with random credentials
sed -i "s/MONGO_INITDB_ROOT_USERNAME: .*/MONGO_INITDB_ROOT_USERNAME: $mongo_user/" docker-compose.yml
sed -i "s/MONGO_INITDB_ROOT_PASSWORD: .*/MONGO_INITDB_ROOT_PASSWORD: $mongo_password/" docker-compose.yml
sed -i "s/MINIO_ROOT_USER: .*/MINIO_ROOT_USER: $minio_root_user/" docker-compose.yml
sed -i "s/MINIO_ROOT_PASSWORD: .*/MINIO_ROOT_PASSWORD: $minio_root_password/" docker-compose.yml

# Update MongoDB connection strings
sed -i "s/MONGO_USER=.*/MONGO_USER=$mongo_user/" docker-compose.yml
sed -i "s/MONGO_PASSWORD=.*/MONGO_PASSWORD=$mongo_password/" docker-compose.yml
sed -i "s|MONGO_URL=.*|MONGO_URL=mongodb://$mongo_user:$mongo_password@myriad-mongo:27017/myriad?authSource=admin|" docker-compose.yml

mkdir -p mongodb/dump/myriad
cd mongodb/dump/myriad
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/currencies.bson
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/currencies.metadata.json
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/networks.bson
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/networks.metadata.json
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/servers.bson
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/servers.metadata.json
cd ../../..
