#!/bin/bash

# install_zrok.sh - Script to install and configure zrok

wget https://github.com/openziti/zrok/releases/download/v0.4.40/zrok_0.4.40_linux_amd64.tar.gz
mkdir zrok
tar -xzvf zrok_0.4.40_linux_amd64.tar.gz -C zrok
cd zrok
./zrok invite
./zrok enable
./zrok share public localhost:8080
./zrok share public localhost:8081
cd ..
