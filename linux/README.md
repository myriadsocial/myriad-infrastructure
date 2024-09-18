# Complete Myriad Setup Guide

This comprehensive guide provides step-by-step instructions for setting up a Docker environment with MongoDB, MinIO, myriad-api, and myriad-web, along with a zrok reverse proxy tunnel for public access. It includes Docker and Docker Compose installation, as well as Myriad Social service setup.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Setup](#setup)
3. [Managing the Myriad Social Service](#managing-the-myriad-social-service)
4. [Troubleshooting](#troubleshooting)
5. [Additional Documentation](#additional-documentation)

## Prerequisites

- An Ubuntu 22.04 server or local machine with sudo privileges
- A stable internet connection
- Basic knowledge of command-line operations

## Setup

For a quick and automated setup, you can use the following script. This will perform all the necessary steps to set up your Myriad environment.

1. Download the `marauder.sh` script using wget:

```bash
wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/marauder.sh
```

2. Make the script executable:

```bash
chmod +x marauder.sh
```

3. Run the script:

```bash
./marauder.sh
```

This script will automatically download and execute all the necessary setup steps for your Myriad environment. It includes:

- Installing Docker and Docker Compose
- Installing and configuring zrok
- Downloading required files
- Setting up MinIO
- Setting up and populating MongoDB
- Setting up the Myriad Social service
- Running Docker Compose to start all services

The script will prompt you for confirmation before running each step, allowing you to control the setup process.

> Note: Make sure you have `wget` installed on your system before running this script. If you don't have it, you can install it using:

```bash
sudo apt update
sudo apt install wget
```

After running the script, your Myriad environment should be set up and ready to use. Make sure to check the console output for any important information or additional steps you might need to take.

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

- To nuke the service you can try:
  ```bash
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker volume rm $(docker volume ls -q)
  sudo systemctl stop myriad-social.service
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
   docker compose -f myriad_setup_scripts/myriad-setup/docker-compose.yml logs mongodb
   ```

6. If MinIO fails to start or you can't access the dashboard, check the MinIO logs:
   ```bash
   docker compose -f myriad_setup_scripts/myriad-setup/docker-compose.yml logs minio
   ```

7. If the Myriad Social service fails to start, check the systemd logs:
   ```bash
   sudo journalctl -u myriad-social.service
   ```

Remember to regularly update your service configuration as needed, monitor your service logs for any issues, and ensure your Docker and Docker Compose setups are properly configured and up-to-date.

For any persistent issues, consult the official documentation for each component or seek help from the Myriad Social community forums or support channels.

## Additional Documentation

For more detailed information on specific components and setup processes, please refer to the following documentation:

- [Ubuntu 22.04 Server Setup Guide](./docs/ubuntu-2204-server-setup.md)
- [Docker Installation Guide](./docs/docker-installation-guide.md)
- [Docker Compose Installation Guide](./docs/docker-compose-installation.md)
- [Nginx Installation Guide](./docs/nginx-installation-guide.md)
- [Nginx Configuration Guide](./docs/nginx-configuration-guide.md)
- [Myriad Service Installation Guide](./docs/myriad-service-installation.md)

These guides provide in-depth instructions for setting up and configuring various components of the Myriad environment.