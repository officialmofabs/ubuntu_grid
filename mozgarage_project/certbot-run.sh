#!/usr/bin/env bash
# Helper to obtain certs (webroot method) - adapt when using Cloudflare DNS plugin
DOMAINS=("ecampuslearning.com" "cccerithparish.org" "officialmofabs.com" "dev.ecampuslearning.com")
EMAIL="admin@ecampuslearning.com"
mkdir -p ./apache/sites
for d in "${DOMAINS[@]}"; do
  mkdir -p ./apache/sites/$d
done
docker run --rm -v $(pwd)/certs:/etc/letsencrypt -v $(pwd)/apache/sites:/var/www/certbot \
  certbot/certbot certonly --webroot -w /var/www/certbot \
  -d ecampuslearning.com -d www.ecampuslearning.com \
  -d cccerithparish.org -d www.cccerithparish.org \
  -d officialmofabs.com -d www.officialmofabs.com \
  -d dev.ecampuslearning.com --email "$EMAIL" --agree-tos --non-interactive
