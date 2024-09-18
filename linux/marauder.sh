#!/bin/bash

# marauder.sh - Main script to run the entire Myriad setup process

set -e

REPO_URL="https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux"

# Function to ask for confirmation
confirm_step() {
    read -p "Do you want to run $1? (y/n): " choice
    case "$choice" in 
        y|Y ) return 0;;
        n|N ) return 1;;
        * ) echo "Invalid input. Skipping step."; return 1;;
    esac
}

# Function to download a script from GitHub
download_script() {
    local script_name=$1
    echo "Downloading $script_name..."
    curl -H "Cache-Control: no-cache" -H "Pragma: no-cache" -O "${REPO_URL}/scripts/${script_name}"
    chmod +x "$script_name"
}

# Function to run a script and check its exit status
run_script() {
    if [ -f "$1" ]; then
        if confirm_step "$1"; then
            echo "Running $1..."
            bash "$1"
            if [ $? -ne 0 ]; then
                echo "Error: $1 failed. Do you want to continue? (y/n): "
                read choice
                if [ "$choice" != "y" ] && [ "$choice" != "Y" ]; then
                    echo "Exiting."
                    exit 1
                fi
            fi
        else
            echo "Skipping $1"
        fi
    else
        echo "Error: $1 not found. Do you want to continue? (y/n): "
        read choice
        if [ "$choice" != "y" ] && [ "$choice" != "Y" ]; then
            echo "Exiting."
            exit 1
        fi
    fi
}

# Create a directory for all the scripts
mkdir -p myriad_setup_scripts
cd myriad_setup_scripts

# Download necessary scripts
download_script "install_docker.sh"
download_script "install_docker_compose.sh"
download_script "install_zrok.sh"
download_script "download_files.sh"
download_script "setup_minio.sh"
download_script "setup_mongodb.sh"
download_script "setup_myriad_service.sh"
download_script "run_docker_compose.sh"

# Download myriad-social.service file
curl -O "${REPO_URL}/scripts/myriad-social.service"

# Make all scripts executable
chmod +x *.sh

# Run all scripts in order, asking for confirmation before each
run_script "install_docker.sh"
run_script "install_docker_compose.sh"
run_script "install_zrok.sh"
run_script "download_files.sh"
run_script "setup_minio.sh"
run_script "setup_mongodb.sh"
run_script "setup_myriad_service.sh"

echo "Myriad setup completed successfully!"
