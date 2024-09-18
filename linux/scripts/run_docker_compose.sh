#!/bin/bash

# run_docker_compose.sh - Script to run Docker Compose

if [ ! -f myriad-setup/docker-compose.yml ]; then
    echo "Error: docker-compose.yml not found. Please run the download_files.sh script first."
    exit 1
fi

# Prompt for zrok URLs
echo "Please provide the zrok URLs for myriad-web and myriad-api:"
read -p "Enter zrok URL for myriad-web (localhost:8080): " myriad_web_url
read -p "Enter zrok URL for myriad-api (localhost:8081): " myriad_api_url

# Validate input
if [ -z "$myriad_web_url" ] || [ -z "$myriad_api_url" ]; then
    echo "Error: Both URLs must be provided."
    exit 1
fi

# Update docker-compose.yml with new URLs
sed -i "s|NEXTAUTH_URL=https://app.testnet.myriad.social|NEXTAUTH_URL=$myriad_web_url|" myriad-setup/docker-compose.yml
sed -i "s|NEXT_PUBLIC_MYRIAD_API_URL=https://api.testnet.myriad.social|NEXT_PUBLIC_MYRIAD_API_URL=$myriad_api_url|" myriad-setup/docker-compose.yml

docker compose -f myriad-setup/docker-compose.yml up -d

echo "Myriad Social service has been set up and started with the following configurations:"
echo "myriad-web URL: $myriad_web_url"
echo "myriad-api URL: $myriad_api_url"
echo "Service is now running. You can check its status with: sudo systemctl status myriad-social.service"

docker compose -f myriad-setup/docker-compose.yml ps
docker compose -f myriad-setup/docker-compose.yml logs
