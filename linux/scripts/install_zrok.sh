#!/bin/bash

# install_zrok.sh - Script to install and configure zrok

wget --no-cache https://github.com/openziti/zrok/releases/download/v0.4.40/zrok_0.4.40_linux_amd64.tar.gz
mkdir zrok
tar -xzvf zrok_0.4.40_linux_amd64.tar.gz -C zrok
cd zrok
./zrok invite

# Prompt user to continue or exit
read -p "Have you finished with the zrok configuration? (y/n): " answer
if [[ $answer != [Yy]* ]]; then
    echo "Exiting script."
    exit 0
fi

# Continue with zrok configuration
./zrok enable
./zrok share public localhost:8080
./zrok share public localhost:8081
cd ..
