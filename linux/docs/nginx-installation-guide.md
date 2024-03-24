# Introduction

[Nginx](https://www.nginx.com/) is highly popular for hosting the largest sites on the internet, suitable as a lightweight web server or reverse proxy. This guide focuses on installing Nginx on Ubuntu 22.04, adjusting the firewall, managing Nginx processes, and setting up server blocks to host multiple domains from a single server.

Deploy your applications efficiently with [DigitalOcean App Platform](https://www.digitalocean.com/products/app-platform).

## Prerequisites

- An Ubuntu 22.04 server, including a `sudo` non-root user and a firewall.

## Step 1 – Installing Nginx

Nginx is available in Ubuntu's default repositories and can be installed using the `apt` package system.

First, update your package index:

```bash
sudo apt update
```

Then, install Nginx:

```bash
sudo apt install nginx
```

Confirm the installation when prompted. Nginx and its dependencies will be installed on your server.

## Step 2 – Adjusting the Firewall

Configure the firewall to allow access to the Nginx service. Nginx registers itself with `ufw` upon installation.

List the application profiles known to `ufw`:

```bash
sudo ufw app list
```

You will see profiles for Nginx:
- Nginx Full: Opens ports 80 and 443.
- Nginx HTTP: Opens port 80 only.
- Nginx HTTPS: Opens port 443 only.

Enable the most appropriate profile, for example, Nginx HTTP:

```bash
sudo ufw allow 'Nginx HTTP'
```

Verify the change:

```bash
sudo ufw status
```

## Step 3 – Checking your Web Server

Ubuntu starts Nginx automatically after installation. Check its status:

```bash
systemctl status nginx
```

## Step 4 – Managing the Nginx Process

Basic Nginx management commands include:

- To stop your web server:

```bash
sudo systemctl stop nginx
```

- To start the web server when stopped:

```bash
sudo systemctl start nginx
```

- To restart the server:

```bash
sudo systemctl restart nginx
```

- For reloading without dropping connections:

```bash
sudo systemctl reload nginx
```

- To disable Nginx from starting at boot:

```bash
sudo systemctl disable nginx
```

- To re-enable Nginx to start at boot:

```bash
sudo systemctl enable nginx
```

## Conclusion

With Nginx installed, you're prepared to serve content and can further explore technologies for a richer web experience. Consider building a LEMP stack on Ubuntu 22.04 or securing Nginx with Let's Encrypt for HTTPS.