#!/bin/bash

# setup_mongodb.sh - Script to set up and populate MongoDB

if [ ! -f myriad-setup/docker-compose.yml ]; then
    echo "Error: Required files not found. Please run the download_files.sh script first."
    exit 1
fi

mkdir -p mongodb_data
docker compose-f myriad-setup/docker-compose.yml up -d mongodb
sleep 10

URI="mongodb://root:password@localhost:27017/myriad?authSource=admin"
mongodump --uri=$URI
mongorestore dump/