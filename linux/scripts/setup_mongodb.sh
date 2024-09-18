#!/bin/bash

# setup_mongodb.sh - Script to set up and populate MongoDB

if [ ! -f myriad-setup/docker-compose.yml ]; then
    echo "Error: docker-compose.yml not found in myriad-setup directory. Please run the download_files.sh script first."
    exit 1
fi

# Read MongoDB credentials from docker-compose.yml
mongo_user=$(grep MONGO_INITDB_ROOT_USERNAME myriad-setup/docker-compose.yml | awk '{print $2}')
mongo_password=$(grep MONGO_INITDB_ROOT_PASSWORD myriad-setup/docker-compose.yml | awk '{print $2}')
mongo_port=$(grep '"27017:27017"' myriad-setup/docker-compose.yml | awk -F'"' '{print $2}' | cut -d':' -f1)

if [ -z "$mongo_user" ] || [ -z "$mongo_password" ] || [ -z "$mongo_port" ]; then
    echo "Error: Unable to read MongoDB credentials or port from docker-compose.yml"
    exit 1
fi

# Create data directory and start MongoDB
mkdir -p mongodb_data
docker compose -f myriad-setup/docker-compose.yml up -d mongodb

echo "Waiting for MongoDB to start..."
sleep 10

# Construct MongoDB URI
URI="mongodb://$mongo_user:$mongo_password@localhost:$mongo_port/myriad?authSource=admin"

# Check if dump directory exists
if [ ! -d "dump" ]; then
    echo "Error: 'dump' directory not found. Please ensure it exists in the current directory."
    exit 1
fi

# Restore data from dump
echo "Restoring data to MongoDB..."
mongorestore --uri="$URI" dump/

if [ $? -ne 0 ]; then
    echo "Error: Failed to restore data to MongoDB. Please check the mongorestore output and try again."
    exit 1
fi

echo "MongoDB setup and data restoration completed successfully."