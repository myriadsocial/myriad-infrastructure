# Nginx Configuration and SSL Setup for Multiple Domains

## Introduction

This guide outlines an automated process for configuring Nginx to host multiple domains and secure them with SSL certificates using Certbot. We'll use a custom script to streamline the process of downloading configuration files, customizing them, setting up Nginx server blocks, and obtaining SSL certificates.

## Prerequisites

- Ubuntu 22.04 server (or similar Linux distribution)
- Nginx installed
- `curl` installed
- Root or sudo access

### Installing Certbot

Before we proceed with the script, we need to ensure Certbot is installed. Here are the steps to install Certbot on Ubuntu:

1. First, update your package list:

```bash
sudo apt update
```

2. Install Certbot and its Nginx plugin:

```bash
sudo apt install certbot python3-certbot-nginx
```

3. Verify the installation:

```bash
certbot --version
```

This should display the version of Certbot installed on your system.

Now that we've ensured Certbot is installed, we can proceed with the rest of the guide.

## Step 1: Prepare the Script

Create a new file named `configure_nginx.sh` in your home directory:

```bash
nano ~/configure_nginx.sh
```

Copy and paste the following script into the file:

```bash
#!/bin/bash

# Prompt for new domain and IP
read -p "Enter the new domain (default: example.com): " NEW_DOMAIN
NEW_DOMAIN=${NEW_DOMAIN:-example.com}

read -p "Enter the new IP (default: 127.0.0.1): " NEW_IP
NEW_IP=${NEW_IP:-127.0.0.1}

# Array of file names
FILES=("api" "app" "storageapi" "storage.dashboard")

# Download and modify files
for FILE in "${FILES[@]}"; do
    curl -o "/etc/nginx/sites-available/${FILE}.${NEW_DOMAIN}" "https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/nginx/${FILE}.myriad.social"
    
    # Replace domain and IP
    sed -i "s/myriad\.social/${NEW_DOMAIN}/g" "/etc/nginx/sites-available/${FILE}.${NEW_DOMAIN}"
    sed -i "s/127\.0\.0\.1/${NEW_IP}/g" "/etc/nginx/sites-available/${FILE}.${NEW_DOMAIN}"
done

# Create symbolic links for new files
for FILE in /etc/nginx/sites-available/*; do
    BASENAME=$(basename "$FILE")
    if [ ! -e "/etc/nginx/sites-enabled/$BASENAME" ]; then
        ln -s "$FILE" "/etc/nginx/sites-enabled/$BASENAME"
        echo "Linked $BASENAME"
    fi
done

# Generate certificates for all domains
DOMAINS=""
for FILE in "${FILES[@]}"; do
    DOMAINS="${DOMAINS} -d ${FILE}.${NEW_DOMAIN}"
done

# Run certbot
certbot --nginx $DOMAINS

echo "Configuration complete!"
```

Save and close the file.

## Step 2: Make the Script Executable

Change the permissions of the script to make it executable:

```bash
chmod +x ~/configure_nginx.sh
```

## Step 3: Run the Script

Execute the script with sudo privileges:

```bash
sudo ~/configure_nginx.sh
```

Follow the prompts to enter your desired domain name and IP address.

## Step 4: Review the Configuration

After the script completes, it's crucial to review the generated configuration files:

```bash
sudo cat /etc/nginx/sites-available/api.yournewdomain.com
sudo cat /etc/nginx/sites-available/app.yournewdomain.com
sudo cat /etc/nginx/sites-available/storageapi.yournewdomain.com
sudo cat /etc/nginx/sites-available/storage.dashboard.yournewdomain.com
```

Make any necessary adjustments to these files based on your specific requirements.

## Step 5: Test Nginx Configuration

Verify that the Nginx configuration is valid:

```bash
sudo nginx -t
```

If there are no errors, reload Nginx to apply the changes:

```bash
sudo systemctl reload nginx
```

## Step 6: Verify SSL Certificates

Check that SSL certificates were successfully obtained and installed for all domains:

```bash
sudo certbot certificates
```

## Step 7: Set Up Auto-Renewal (Optional)

Certbot typically sets up auto-renewal by default, but you can verify it:

```bash
sudo systemctl status certbot.timer
```

To test the renewal process:

```bash
sudo certbot renew --dry-run
```

## Conclusion

You've now automated the process of configuring Nginx for multiple domains and securing them with SSL certificates. This script streamlines the setup process, reducing the chance of manual errors and saving time.

Remember to:
- Regularly update your Nginx configurations as needed
- Keep your SSL certificates up to date
- Monitor your Nginx and Certbot logs for any issues

For any changes or additions to your domain configuration, you can modify the script or manually adjust the Nginx configuration files as needed.

Would you like me to explain any part of this guide in more detail?