#!/bin/bash

# run_docker_compose.sh - Script to run Docker Compose

if [ ! -f docker-compose.yml ]; then
    echo "Error: docker-compose.yml not found. Please run the download_files.sh script first."
    exit 1
fi

docker compose-f myriad_setup_scripts/myriad-setup/docker-compose.yml up -d
docker composeps
docker composelogs
