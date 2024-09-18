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

# Comprehensive Docker Myriad Setup Guide

This guide provides step-by-step instructions for setting up a Docker environment with MongoDB, MinIO, myriad-api, and myriad-web, along with a zrok reverse proxy tunnel for public access. It includes Docker and Docker Compose installation, as well as Myriad Social service setup.

## Table of Contents
1. [Install Docker](#1-install-docker)
2. [Install Docker Compose](#2-install-docker-compose)
3. [Install and Configure zrok](#3-install-and-configure-zrok)
4. [Download Required Files](#4-download-required-files)
5. [Edit the Docker Compose File](#5-edit-the-docker-compose-file)
6. [Set up MinIO](#6-set-up-minio)
7. [Prepare and Populate MongoDB](#7-prepare-and-populate-mongodb)
8. [Set Up Myriad Social Service](#8-set-up-myriad-social-service)
9. [Run Docker Compose](#9-run-docker-compose)

## 1. Install Docker

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

## 2. Install Docker Compose

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

## 3. Install and Configure zrok

[Previous zrok installation steps remain the same]

## 4. Download Required Files

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

## 5. Edit the Docker Compose File

[Previous Docker Compose file editing steps remain the same]

## 6. Set up MinIO

[Previous MinIO setup steps remain the same]

## 7. Prepare and Populate MongoDB

[Previous MongoDB preparation and population steps remain the same]

## 8. Set Up Myriad Social Service

8.1. Create an installation script:
```bash
nano install_myriad_service.sh
```

8.2. Copy and paste the following content into the file:
```bash
#!/bin/bash

# Function to prompt for user input with a default value
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local response

    read -p "$prompt [$default]: " response
    echo "${response:-$default}"
}

# Prompt for the user who will run the docker compose
user=$(prompt_with_default "Enter the user who will run the docker compose" "$(whoami)")

# Edit the service file
sed -i "s|/home/user|/home/$user|g" myriad-social.service

# Move the service file to the systemd directory
sudo mv myriad-social.service /etc/systemd/system/

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable myriad-social.service

# Start the service
sudo systemctl start myriad-social.service

echo "Myriad Social service has been installed, enabled, and started."
echo "You can check its status with: sudo systemctl status myriad-social.service"
```

8.3. Make the script executable:
```bash
chmod +x install_myriad_service.sh
```

8.4. Run the installation script:
```bash
sudo ./install_myriad_service.sh
```

8.5. Verify the service installation:
```bash
sudo systemctl status myriad-social.service
```

## 9. Run Docker Compose

9.1. Start all services:
```bash
docker compose up -d
```

9.2. Verify that all services are running:
```bash
docker compose ps
```

9.3. Check the logs for any errors:
```bash
docker compose logs
```

9.4. Access your applications:
   - Myriad Web: https://app.your.domain
   - Myriad API: https://api.your.domain
   - MinIO Dashboard: http://localhost:9001

Congratulations! You have successfully set up your Docker environment with MongoDB, MinIO, myriad-api, and myriad-web, accessible through zrok reverse proxy tunnels. The MongoDB database has been populated with the necessary initial data, and the Myriad Social service is set up to manage the Docker Compose stack.

## Managing the Myriad Social Service

- To stop the service:
  ```bash
  sudo systemctl stop myriad-social.service
  ```

- To start the service:
  ```bash
  sudo systemctl start myriad-social.service
  ```

- To restart the service:
  ```bash
  sudo systemctl restart myriad-social.service
  ```

- To disable the service from starting at boot:
  ```bash
  sudo systemctl disable myriad-social.service
  ```

Remember to regularly update your service configuration as needed, monitor your service logs for any issues, and ensure your Docker and Docker Compose setups are properly configured.
