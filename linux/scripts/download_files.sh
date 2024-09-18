#!/bin/bash

# download_files.sh - Script to download required files

mkdir -p myriad-setup
cd myriad-setup

wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/docker/docker-compose.yml

mkdir -p mongodb/dump/myriad
cd mongodb/dump/myriad
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/currencies.bson
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/currencies.metadata.json
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/networks.bson
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/networks.metadata.json
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/servers.bson
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/servers.metadata.json
cd ../../..
