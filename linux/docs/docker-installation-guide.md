# Introduction to Docker on Ubuntu 22.04

Docker simplifies the management of application processes in containers, offering portability and efficiency compared to virtual machines. This tutorial guides you through installing Docker Community Edition (CE) on Ubuntu 22.04, working with containers and images, and pushing images to a Docker Repository.

## Prerequisites

- An Ubuntu 22.04 server, including a `sudo` non-root user and a firewall.
- A [Docker Hub](https://hub.docker.com/) account for creating and pushing your own images.

## Step 1: Installing Docker

1. Update your package list:
   ```bash
   sudo apt update
   ```
2. Install packages to allow `apt` to use a repository over HTTPS:
   ```bash
   sudo apt install apt-transport-https ca-certificates curl software-properties-common
   ```
3. Add Docker's official GPG key:
   ```bash
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   ```
4. Set up the stable Docker repository:
   ```bash
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```
5. Install Docker CE:
   ```bash
   sudo apt update
   sudo apt install docker-ce
   ```
6. Verify that Docker is running:
   ```bash
   sudo systemctl status docker
   ```

## Step 2: Executing Docker Without Sudo (Optional)

1. Add your user to the `docker` group:
   ```bash
   sudo usermod -aG docker ${USER}
   ```
2. Apply the new group membership by logging out and back in, or switching to the added user:
   ```bash
   su - ${USER}
   ```

## Step 3: Using the Docker Command

- The `docker` command syntax includes options, commands, and arguments. For a list of subcommands:
  ```bash
  docker
  ```

## Step 4: Working with Docker Images

- Run a `hello-world` container to verify that Docker can pull and run images:
   ```bash
   docker run hello-world
   ```

## Conclusion

By completing this tutorial, you've installed Docker, learned to manage containers and images, and pushed an image to Docker Hub.