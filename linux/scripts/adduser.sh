#!/bin/bash

# Prompt for the new username
read -p "Enter the new username: " username

# Prompt for the user's public key with a sentinel for multi-line input
echo "Enter the public SSH key for the user (paste below, then type EOF on a new line to finish):"
sshkey=""
while IFS= read -r line; do
    [[ $line == "EOF" ]] && break
    sshkey+="$line\n"
done

# Create the new user (with a home directory)
adduser $username

# Add the new user to the sudo group
usermod -aG sudo $username

# Set up SSH keys for the new user
mkdir -p /home/$username/.ssh
echo -e $sshkey > /home/$username/.ssh/authorized_keys

# Set correct permissions for .ssh and authorized_keys
chown -R $username:$username /home/$username/.ssh
chmod 700 /home/$username/.ssh
chmod 600 /home/$username/.ssh/authorized_keys

echo "User $username has been created and added to sudo group. SSH key has been set up."