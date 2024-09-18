#!/bin/bash

# setup_mongodb.sh - Script to set up and populate MongoDB

if [ ! -f myriad-setup/docker-compose.yml ]; then
    echo "Error: docker-compose.yml not found in myriad-setup directory. Please run the download_files.sh script first."
    exit 1
fi

# Check if mongorestore is already installed
if ! command -v mongorestore &> /dev/null; then
    echo "mongorestore not found. Downloading and installing MongoDB database tools..."
    
    # Download and install MongoDB database tools
    wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.10.0.deb
    
    echo "Installing MongoDB database tools..."
    sudo dpkg -i mongodb-database-tools-ubuntu2204-x86_64-100.10.0.deb
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install MongoDB database tools. Please check the installation output and try again."
        exit 1
    fi
    
    # Clean up the downloaded .deb file
    rm mongodb-database-tools-ubuntu2204-x86_64-100.10.0.deb
else
    echo "mongorestore is already installed. Proceeding with MongoDB setup."
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
sleep 20

# Construct MongoDB URI
URI="mongodb://$mongo_user:$mongo_password@localhost:$mongo_port/myriad?authSource=admin"

# Check if dump directory exists
if [ ! -d "myriad-setup/mongodb/dump" ]; then
    echo "Error: 'myriad-setup/mongodb/dump' directory not found. Please ensure it exists."
    exit 1
fi

# Restore data from dump
echo "Restoring data to MongoDB..."
mongorestore --uri="$URI" myriad-setup/mongodb/dump/

if [ $? -ne 0 ]; then
    echo "Error: Failed to restore data to MongoDB. Please check the mongorestore output and try again."
    exit 1
fi

echo "MongoDB setup and data restoration completed successfully."