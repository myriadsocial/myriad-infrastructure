#!/bin/bash

# install_zrok.sh - Script to install and configure zrok

wget --no-cache https://github.com/openziti/zrok/releases/download/v0.4.40/zrok_0.4.40_linux_amd64.tar.gz
mkdir zrok
tar -xzvf zrok_0.4.40_linux_amd64.tar.gz -C zrok
cd zrok
./zrok invite

echo "If you haven't register for a zrok account and obtain a token."

# Prompt user for zrok token
read -p "Please enter your zrok token: " zrok_token

if [ -z "$zrok_token" ]; then
    echo "No token provided. Exiting script."
    exit 1
fi

# Continue with zrok configuration
echo "Enabling zrok with provided token..."
./zrok enable "$zrok_token"

if [ $? -ne 0 ]; then
    echo "Error: Failed to enable zrok. Please check your token and try again."
    exit 1
fi

echo "Setting up public shares..."
./zrok share public localhost:8080
./zrok share public localhost:8081

echo "zrok installation and configuration completed."
cd ..
