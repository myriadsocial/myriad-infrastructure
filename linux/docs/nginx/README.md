# Nginx Configuration Files

This directory contains Nginx server block configuration files for various subdomains of the Myriad Social application. These files are designed to be used with Nginx as a reverse proxy to route traffic to the appropriate services.

## Files

1. `api.myriad.social`
   - Configuration for the API subdomain
   - Proxies requests to the Myriad API service

2. `app.myriad.social`
   - Configuration for the main application subdomain
   - Proxies requests to the Myriad web application

3. `storage.dashboard.myriad.social`
   - Configuration for the storage dashboard subdomain
   - Proxies requests to the MinIO console

4. `storageapi.myriad.social`
   - Configuration for the storage API subdomain
   - Proxies requests to the MinIO API

## Usage

To use these configuration files:

1. Copy them to your Nginx configuration directory (typically `/etc/nginx/sites-available/`).
2. Create symbolic links to these files in the `/etc/nginx/sites-enabled/` directory.
3. Customize the server names and proxy pass locations as needed for your specific setup.
4. Test the Nginx configuration with `nginx -t`.
5. Reload Nginx to apply the changes: `sudo systemctl reload nginx`.

## Important Notes

- These configurations assume you're running services on localhost. Adjust the `proxy_pass` directives if your services are running on different hosts or ports.
- SSL/TLS configuration is not included in these files. It's recommended to use Certbot or another SSL solution to secure your subdomains.
- Make sure to replace `myriad.social` with your actual domain name in the `server_name` directives.

For more detailed information on setting up Nginx for Myriad Social, please refer to the [Nginx Configuration Guide](../nginx-configuration-guide.md) in the parent directory.