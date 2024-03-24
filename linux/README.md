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