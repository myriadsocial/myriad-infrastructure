# Myriad Social Service Setup

## Introduction

This guide outlines an automated process for configuring and installing a systemd service for Myriad Social. We'll use a custom script to streamline the process of downloading the service file, customizing it, and setting it up as a systemd service.

## Prerequisites

- Ubuntu 22.04 server (or similar Linux distribution)
- `curl` installed
- Root or sudo access
- Docker and Docker Compose installed (for running Myriad Social)

## Step 1: Prepare the Script

Create a new file named `install_myriad_service.sh` in your home directory:

```bash
nano ~/install_myriad_service.sh
```

Copy and paste the following script into the file:

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

# Download the service file
curl -o myriad-social.service https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/myriad-social.service

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

Save and close the file.

## Step 2: Make the Script Executable

Change the permissions of the script to make it executable:

```bash
chmod +x ~/install_myriad_service.sh
```

## Step 3: Run the Script

Execute the script with sudo privileges:

```bash
sudo ~/install_myriad_service.sh
```

Follow the prompt to enter the username who will run the Docker Compose for Myriad Social.

## Step 4: Verify the Service Installation

After the script completes, verify that the service was installed correctly:

```bash
sudo systemctl status myriad-social.service
```

This should show the service as active (running).

## Step 5: Review the Service Configuration

It's crucial to review the generated service file:

```bash
sudo nano /etc/systemd/system/myriad-social.service
```

Make any necessary adjustments based on your specific requirements.

## Step 6: Managing the Service

Here are some useful commands for managing the Myriad Social service:

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

## Conclusion

You've now automated the process of configuring and installing a systemd service for Myriad Social. This script streamlines the setup process, reducing the chance of manual errors and saving time.

Remember to:
- Regularly update your service configuration as needed
- Monitor your service logs for any issues
- Ensure your Docker and Docker Compose setups are properly configured

For any changes or additions to your service configuration, you can modify the script or manually adjust the systemd service file as needed.