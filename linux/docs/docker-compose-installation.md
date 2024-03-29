# Detailed Guide: Docker Compose on Ubuntu 22.04

## Introduction
Docker Compose simplifies the management of application processes in containers, which are more lightweight and resource-efficient compared to virtual machines. This tool helps in orchestrating multiple containers, allowing them to start up, communicate, and shut down in unison based on definitions set in a YAML file.

## Prerequisites
To follow this guide, you will need:
- An Ubuntu 22.04 server or local machine with sudo privileges.
- Docker installed.

## Step 1 — Installing Docker Compose
1. Check the latest version of Docker Compose on the official GitHub [releases page](https://github.com/docker/compose/releases).
2. Download Docker Compose using the command:
    ```
    mkdir -p ~/.docker/cli-plugins/
    curl -SL https://github.com/docker/compose/releases/download/v2.26.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
    ```
3. Set the executable permission for the downloaded binary:
    ```
    chmod +x ~/.docker/cli-plugins/docker-compose
    ```
4. Verify the installation:
    ```
    docker compose version
    ```

## Step 2 — Setting Up a `docker-compose.yml` File
1. Create a directory for your project:
    ```
    mkdir ~/compose-demo
    cd ~/compose-demo
    ```
2. Inside this directory, create an `app` folder and an `index.html` file with your content.
3. Create a `docker-compose.yml` file in the project directory:
    ```yaml
    version: '3.7'
    services:
      web:
        image: nginx:alpine
        ports:
          - "8000:80"
        volumes:
          - ./app:/usr/share/nginx/html
    ```
   This configuration tells Docker Compose to run a web service using the `nginx:alpine` image, redirecting port 8000 on the host to port 80 in the container, and sharing the `app` folder between the host and container.

## Step 3 — Running Docker Compose
Start the environment:
    ```
    docker compose up -d
    ```
   This command downloads necessary images, creates services, and runs them in the background.

## Step 4 — Getting Familiar with Basic Docker Compose Commands
- View logs:
    ```
    docker compose logs
    ```
- Completely remove the containers, networks, and volumes:
    ```
    docker compose down
    ```

## Conclusion
The guide covered installing Docker Compose on Ubuntu 22.04, setting up a `docker-compose.yml` file for a simple web server environment, and managing the environment with Docker Compose commands. For further information, refer to the [official Docker Compose documentation](https://docs.docker.com/compose/reference/).
