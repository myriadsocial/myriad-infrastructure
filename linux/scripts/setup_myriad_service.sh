#!/bin/bash

# setup_myriad_service.sh - Script to set up Myriad Social service

if [ ! -f myriad-social.service ]; then
    echo "Error: myriad-social.service not found. Please run the download_files.sh script first."
    exit 1
fi

user=$(whoami)
sed -i "s|/home/user|/home/$user|g" myriad-social.service
sudo mv myriad-social.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable myriad-social.service
sudo systemctl start myriad-social.service
