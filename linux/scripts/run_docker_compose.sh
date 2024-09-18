#!/bin/bash

# run_docker_compose.sh - Script to run Docker Compose

if [ ! -f docker-compose.yml ]; then
    echo "Error: docker-compose.yml not found. Please run the download_files.sh script first."
    exit 1
fi

docker-compose up -d
docker-compose ps
docker-compose logs
