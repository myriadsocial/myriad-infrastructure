#!/bin/bash

# download_files.sh - Script to download required files

mkdir -p myriad-setup
cd myriad-setup

wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/docker-compose.yml
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/myriad-social.service
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/migrate_mongodb.sh
chmod +x migrate_mongodb.sh

mkdir -p mongodb/dump/myriad
cd mongodb/dump/myriad
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/currencies.bson
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/currencies.metadata.json
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/networks.bson
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/networks.metadata.json
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/servers.bson
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/servers.metadata.json
cd ../../..
