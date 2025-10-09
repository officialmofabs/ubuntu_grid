#!/bin/bash
BACKUP_DIR=/opt/mozgarage/backups
mkdir -p $BACKUP_DIR
DATE=$(date +%F_%H-%M-%S)
tar -czf $BACKUP_DIR/mozgarage_$DATE.tar.gz ./certs ./apache ./docker-compose.yml
find $BACKUP_DIR -type f -mtime +7 -delete
