# Ubuntu 22.04 Server Setup Guide

This comprehensive guide covers the installation and basic configuration of Docker, Docker Compose, and Nginx on Ubuntu 22.04. It's designed to help you set up a server environment that's ready for deploying web applications, including the preparation for a Myriad Social instance.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installing Docker on Ubuntu 22.04](#installing-docker-on-ubuntu-2204)
- [Installing Docker Compose on Ubuntu 22.04](#installing-docker-compose-on-ubuntu-2204)
- [Installing Nginx on Ubuntu 22.04](#installing-nginx-on-ubuntu-2204)
- [Conclusion](#conclusion)
- [Further Resources](#further-resources)

## Introduction

Deploying applications efficiently requires a solid foundation. Docker and Docker Compose simplify the management and orchestration of containerized applications, while Nginx offers a robust platform for serving web content and acting as a reverse proxy. This guide is your step-by-step companion for setting up these essential tools on an Ubuntu 22.04 server.

## Prerequisites

Before you begin, ensure you have:

- An Ubuntu 22.04 server set up with a non-root `sudo` user and a firewall.

## Installing Docker on Ubuntu 22.04

Docker CE (Community Edition) installation involves updating your package list, installing required packages for repository management over HTTPS, adding Docker's official GPG key, setting up the Docker repository, and finally, installing Docker CE itself.

After installation, verify Docker is running and optionally, add your user to the `docker` group to execute Docker commands without `sudo`.

[Detailed Docker Installation Steps](./docs/docker-installation-guide.md)

## Installing Docker Compose on Ubuntu 22.04

With Docker installed, the next step is to install Docker Compose, which facilitates the management of multi-container Docker applications. Check the latest version on Docker Compose's GitHub releases page, download the Docker Compose binary, set the correct permissions, and verify the installation.

Docker Compose relies on a YAML file to configure your application's services, which means you can start, stop, and rebuild services based on your configuration.

[Detailed Docker Compose Installation Steps](./docs/docker-compose-installation.md)

## Installing Nginx on Ubuntu 22.04

Nginx is a high-performance web server and reverse proxy. The installation includes adding Nginx to your system from Ubuntu's repositories, adjusting the firewall to allow web traffic, and performing basic management tasks like starting and stopping the service.

This section also guides you through setting up server blocks (similar to virtual hosts in Apache) to host multiple domains from a single server.

[Detailed Nginx Installation Steps](./docs/nginx-installation-guide.md)

## Conclusion

By following this guide, you have set up a robust server environment on Ubuntu 22.04, ready for deploying containerized applications with Docker and Docker Compose, and serving web content with Nginx. This foundation is perfect for hosting a variety of web applications, including a Myriad Social instance.

## Further Resources

To deepen your knowledge and explore more about Docker, Docker Compose, and Nginx, visit the following resources:

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)

This README serves as an overview. For detailed commands and configuration steps, refer to the linked sections within this document.

---

# Complete Myriad Setup Guide

This comprehensive guide provides step-by-step instructions for setting up a Docker environment with MongoDB, MinIO, myriad-api, and myriad-web, along with a zrok reverse proxy tunnel for public access. It includes Docker and Docker Compose installation, as well as Myriad Social service setup.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Automated Setup](#automated-setup)
3. [Manual Setup](#manual-setup)
   1. [Install Docker](#1-install-docker)
   2. [Install Docker Compose](#2-install-docker-compose)
   3. [Install and Configure zrok](#3-install-and-configure-zrok)
   4. [Download Required Files](#4-download-required-files)
   5. [Edit the Docker Compose File](#5-edit-the-docker-compose-file)
   6. [Set up MinIO](#6-set-up-minio)
   7. [Prepare and Populate MongoDB](#7-prepare-and-populate-mongodb)
   8. [Set Up Myriad Social Service](#8-set-up-myriad-social-service)
   9. [Run Docker Compose](#9-run-docker-compose)
4. [Managing the Myriad Social Service](#managing-the-myriad-social-service)
5. [Troubleshooting](#troubleshooting)

## Prerequisites

- An Ubuntu 22.04 server or local machine with sudo privileges
- A stable internet connection
- Basic knowledge of command-line operations

## Automated Setup

For a quick and automated setup, you can use the following script suite. This will perform all the necessary steps to set up your Myriad environment.

1. Create a file named `main_setup.sh` with the following content:

```bash
#!/bin/bash

# main_setup.sh - Main script to run the entire Myriad setup process

set -e

# Function to run a script and check its exit status
run_script() {
    if [ -f "$1" ]; then
        echo "Running $1..."
        bash "$1"
        if [ $? -ne 0 ]; then
            echo "Error: $1 failed. Exiting."
            exit 1
        fi
    else
        echo "Error: $1 not found. Exiting."
        exit 1
    fi
}

# Create a directory for all the scripts
mkdir -p myriad_setup_scripts
cd myriad_setup_scripts

# Download all the necessary scripts
cat << 'EOF' > download_scripts.sh
#!/bin/bash

# download_scripts.sh - Script to download all necessary setup scripts

download_script() {
    wget -O "$1" "https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/setup_scripts/$1"
    chmod +x "$1"
}

download_script "install_docker.sh"
download_script "install_docker_compose.sh"
download_script "install_zrok.sh"
download_script "download_files.sh"
download_script "setup_minio.sh"
download_script "setup_mongodb.sh"
download_script "setup_myriad_service.sh"
download_script "run_docker_compose.sh"
EOF

chmod +x download_scripts.sh

# Create individual setup scripts
cat << 'EOF' > install_docker.sh
#!/bin/bash

# install_docker.sh - Script to install Docker

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker ${USER}
EOF

cat << 'EOF' > install_docker_compose.sh
#!/bin/bash

# install_docker_compose.sh - Script to install Docker Compose

mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.26.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
EOF

cat << 'EOF' > install_zrok.sh
#!/bin/bash

# install_zrok.sh - Script to install and configure zrok

wget https://github.com/openziti/zrok/releases/download/v0.4.40/zrok_0.4.40_linux_amd64.tar.gz
mkdir zrok
tar -xzvf zrok_0.4.40_linux_amd64.tar.gz -C zrok
cd zrok
./zrok invite
./zrok enable
./zrok share public localhost:8080 --name myriad-web
./zrok share public localhost:8081 --name myriad-api
cd ..
EOF

cat << 'EOF' > download_files.sh
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
EOF

cat << 'EOF' > setup_minio.sh
#!/bin/bash

# setup_minio.sh - Script to set up MinIO

# Start MinIO container
docker-compose up -d minio

# Wait for MinIO to start
sleep 10

# Create access key and secret key
access_key=$(docker-compose exec -T minio mc admin user add local accesskey secretkey)
secret_key=$(docker-compose exec -T minio mc admin user info local accesskey | grep SecretKey | awk '{print $2}')

# Update docker-compose.yml with MinIO keys
sed -i "s/MINIO_ACCESS_KEY=.*/MINIO_ACCESS_KEY=$access_key/" docker-compose.yml
sed -i "s/MINIO_SECRET_KEY=.*/MINIO_SECRET_KEY=$secret_key/" docker-compose.yml
EOF

cat << 'EOF' > setup_mongodb.sh
#!/bin/bash

# setup_mongodb.sh - Script to set up and populate MongoDB

mkdir -p mongodb_data
docker-compose up -d mongodb
sleep 10
./migrate_mongodb.sh
EOF

cat << 'EOF' > setup_myriad_service.sh
#!/bin/bash

# setup_myriad_service.sh - Script to set up Myriad Social service

user=$(whoami)
sed -i "s|/home/user|/home/$user|g" myriad-social.service
sudo mv myriad-social.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable myriad-social.service
sudo systemctl start myriad-social.service
EOF

cat << 'EOF' > run_docker_compose.sh
#!/bin/bash

# run_docker_compose.sh - Script to run Docker Compose

docker-compose up -d
docker-compose ps
docker-compose logs
EOF

# Make all scripts executable
chmod +x *.sh

# Run all scripts in order
run_script "download_scripts.sh"
run_script "install_docker.sh"
run_script "install_docker_compose.sh"
run_script "install_zrok.sh"
run_script "download_files.sh"
run_script "setup_minio.sh"
run_script "setup_mongodb.sh"
run_script "setup_myriad_service.sh"
run_script "run_docker_compose.sh"

echo "Myriad setup completed successfully!"
```

2. Make the script executable:

```bash
chmod +x main_setup.sh
```

3. Run the script:

```bash
./main_setup.sh
```

This script will automate the entire setup process. However, if you prefer to perform the setup manually or need more control over each step, follow the manual setup instructions below.

## Manual Setup

### 1. Install Docker

1.1. Update your package list:
```bash
sudo apt update
```

1.2. Install packages to allow `apt` to use a repository over HTTPS:
```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

1.3. Add Docker's official GPG key:
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

1.4. Set up the stable Docker repository:
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

1.5. Install Docker CE:
```bash
sudo apt update
sudo apt install docker-ce
```

1.6. Verify that Docker is running:
```bash
sudo systemctl status docker
```

1.7. (Optional) Execute Docker without sudo:
```bash
sudo usermod -aG docker ${USER}
su - ${USER}
```

### 2. Install Docker Compose

2.1. Create the Docker CLI plugins directory:
```bash
mkdir -p ~/.docker/cli-plugins/
```

2.2. Download Docker Compose:
```bash
curl -SL https://github.com/docker/compose/releases/download/v2.26.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
```

2.3. Set the executable permission:
```bash
chmod +x ~/.docker/cli-plugins/docker-compose
```

2.4. Verify the installation:
```bash
docker compose version
```

### 3. Install and Configure zrok

3.1. Download zrok:
```bash
wget https://github.com/openziti/zrok/releases/download/v0.4.40/zrok_0.4.40_linux_amd64.tar.gz
```

3.2. Extract the archive:
```bash
mkdir zrok
tar -xzvf zrok_0.4.40_linux_amd64.tar.gz -C zrok
cd zrok
```

3.3. Set up zrok:
```bash
./zrok invite
./zrok enable
```

3.4. Create reverse proxy tunnels for myriad-web and myriad-api:
```bash
./zrok share public localhost:8080 --name myriad-web
./zrok share public localhost:8081 --name myriad-api
```

3.5. Note down the generated public URLs for myriad-web (`app.your.domain`) and myriad-api (`api.your.domain`).

### 4. Download Required Files

4.1. Create a directory for the project:
```bash
mkdir myriad-setup
cd myriad-setup
```

4.2. Download the Docker Compose YAML file:
```bash
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/docker-compose.yml
```

4.3. Download the Myriad Social service file:
```bash
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/myriad-social.service
```

4.4. Download the MongoDB migration script:
```bash
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/migrate_mongodb.sh
chmod +x migrate_mongodb.sh
```

4.5. Create a directory for MongoDB dump files and download them:
```bash
mkdir -p mongodb/dump/myriad
cd mongodb/dump/myriad
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/currencies.bson
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/currencies.metadata.json
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/networks.bson
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/networks.metadata.json
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/servers.bson
wget https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/mongodb/dump/myriad/servers.metadata.json
cd ../../..
```

### 5. Edit the Docker Compose File

5.1. Open the Docker Compose file in a text editor:
```bash
nano docker-compose.yml
```

5.2. Update the environment variables for myriad-web:
```yaml
myriad-web:
  environment:
    - NEXT_PUBLIC_APP_ENVIRONMENT=testnet
    - NEXT_PUBLIC_APP_NAME=Myriad App
    - NEXT_PUBLIC_APP_VERSION=2.1.20
    - NEXTAUTH_URL=https://app.your.domain
    - APP_SECRET=<generate-a-random-secret>
    - NEXT_PUBLIC_MYRIAD_API_URL=https://api.your.domain
```

5.3. Update the environment variables for myriad-api:
```yaml
myriad-api:
  environment:
    - DOMAIN=api.your.domain
    - MYRIAD_ADMIN_SUBSTRATE_MNEMONIC=<keep-existing-value>
    - MYRIAD_ADMIN_NEAR_MNEMONIC=<keep-existing-value>
    - JWT_TOKEN_SECRET_KEY=<generate-a-random-secret>
    - JWT_REFRESH_TOKEN_SECRET_KEY=<generate-a-random-secret>
```

5.4. Randomize usernames and passwords for MongoDB and MinIO:
```yaml
mongodb:
  environment:
    - MONGO_INITDB_ROOT_USERNAME=<random-username>
    - MONGO_INITDB_ROOT_PASSWORD=<random-password>

minio:
  environment:
    - MINIO_ROOT_USER=<random-username>
    - MINIO_ROOT_PASSWORD=<random-password>
```

### 6. Set up MinIO

6.1. Start MinIO container:
```bash
docker-compose up -d minio
```

6.2. Wait for MinIO to start (approximately 10 seconds)

6.3. Create access key and secret key:
```bash
access_key=$(docker-compose exec -T minio mc admin user add local accesskey secretkey)
secret_key=$(docker-compose exec -T minio mc admin user info local accesskey | grep SecretKey | awk '{print $2}')
```

6.4. Update docker-compose.yml with MinIO keys:
```bash
sed -i "s/MINIO_ACCESS_KEY=.*/MINIO_ACCESS_KEY=$access_key/" docker-compose.yml
sed -i "s/MINIO_SECRET_KEY=.*/MINIO_SECRET_KEY=$secret_key/" docker-compose.yml
```

### 7. Prepare and Populate MongoDB

7.1. Create necessary directories for MongoDB data:
```bash
mkdir -p mongodb_data
```

7.2. Update the Docker Compose file to mount the MongoDB data directory:
```yaml
mongodb:
  volumes:
    - ./mongodb_data:/data/db
```

7.3. Start MongoDB container:
```bash
docker-compose up -d mongodb
```

7.4. Wait for MongoDB to start (approximately 10 seconds)

7.5. Run the MongoDB migration script:
```bash
./migrate_mongodb.sh
```

### 8. Set Up Myriad Social Service

8.1. Edit the Myriad Social service file:
```bash
nano myriad-social.service
```

8.2. Update the `ExecStart` line to point to your Docker Compose file location:
```
ExecStart=/usr/local/bin/docker-compose -f /path/to/your/docker-compose.yml up -d
```

8.3. Move the service file to the systemd directory:
```bash
sudo mv myriad-social.service /etc/systemd/system/
```

8.4. Reload systemd and enable the service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable myriad-social.service
```

### 9. Run Docker Compose

9.1. Start all services:
```bash
docker-compose up -d
```

9.2. Verify that all services are running:
```bash
docker-compose ps
```

9.3. Check the logs for any errors:
```bash
docker-compose logs
```

9.4. Access your applications:
   - Myriad Web: https://app.your.domain
   - Myriad API: https://api.your.domain
   - MinIO Dashboard: http://localhost:9001

## Managing the Myriad Social Service

- To start the service:
  ```bash
  sudo systemctl start myriad-social.service
  ```

- To stop the service:
  ```bash
  sudo systemctl stop myriad-social.service
  ```

- To restart the service:
  ```bash
  sudo systemctl restart myriad-social.service
  ```

- To check the status of the service:
  ```bash
  sudo systemctl status myriad-social.service
  ```

- To view the service logs:
  ```bash
  sudo journalctl -u myriad-social.service
  ```

- To disable the service from starting at boot:
  ```bash
  sudo systemctl disable myriad-social.service
  ```

## Troubleshooting

1. If you encounter permission issues, make sure you have the necessary sudo privileges or are running the commands as root.

2. If Docker fails to start, check if the Docker daemon is running:
   ```bash
   sudo systemctl status docker
   ```
   If it's not running, start it with:
   ```bash
   sudo systemctl start docker
   ```

3. If you can't connect to the Docker daemon, make sure your user is in the docker group:
   ```bash
   sudo usermod -aG docker ${USER}
   ```
   Then, log out and log back in for the changes to take effect.

4. If zrok fails to create tunnels, check your firewall settings and make sure the necessary ports are open.

5. If MongoDB fails to start or populate, check the MongoDB logs:
   ```bash
   docker-compose logs mongodb
   ```

6. If MinIO fails to start or you can't access the dashboard, check the MinIO logs:
   ```bash
   docker-compose logs minio
   ```

7. If the Myriad Social service fails to start, check the systemd logs:
   ```bash
   sudo journalctl -u myriad-social.service
   ```

Remember to regularly update your service configuration as needed, monitor your service logs for any issues, and ensure your Docker and Docker Compose setups are properly configured and up-to-date.

For any persistent issues, consult the official documentation for each component or seek help from the Myriad Social community forums or support channels.
