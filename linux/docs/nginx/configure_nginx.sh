# DEPRECATED #

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