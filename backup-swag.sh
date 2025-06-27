#!/bin/bash

# SWAG Backup Script
# This script safely backs up SWAG configuration and certificates
# Run this script from the financial-tracker-infra directory

set -e

# Configuration
BACKUP_DIR="./swag-backup"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="swag-backup-${DATE}.tar.gz"
ENCRYPTED_BACKUP_NAME="swag-backup-${DATE}.tar.gz.enc"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔐 SWAG Backup Script${NC}"
echo "=================================="

# Check if SWAG container is running
if ! docker ps | grep -q swag; then
    echo -e "${RED}❌ SWAG container is not running. Please start it first.${NC}"
    exit 1
fi

# Create backup directory
echo -e "${YELLOW}📁 Creating backup directory...${NC}"
mkdir -p "${BACKUP_DIR}"

# Backup critical SWAG files
echo -e "${YELLOW}🔒 Backing up SSL certificates and keys...${NC}"
docker cp swag:/config/keys "${BACKUP_DIR}/"

echo -e "${YELLOW}📝 Backing up custom nginx configurations...${NC}"
docker cp swag:/config/nginx/site-confs "${BACKUP_DIR}/"

# Backup SWAG environment variables
echo -e "${YELLOW}⚙️  Backing up SWAG environment variables...${NC}"
docker inspect swag --format='{{range .Config.Env}}{{println .}}{{end}}' > "${BACKUP_DIR}/swag-env.txt"

# Backup SWAG container configuration
echo -e "${YELLOW}🐳 Backing up container configuration...${NC}"
docker inspect swag > "${BACKUP_DIR}/swag-container-info.json"

# Create tar archive
echo -e "${YELLOW}📦 Creating backup archive...${NC}"
tar -czf "${BACKUP_NAME}" -C "${BACKUP_DIR}" .

# Clean up temporary directory
rm -rf "${BACKUP_DIR}"

echo -e "${GREEN}✅ Backup created: ${BACKUP_NAME}${NC}"
echo -e "${YELLOW}📊 Backup size: $(du -h "${BACKUP_NAME}" | cut -f1)${NC}"

# Optional: Encrypt the backup
read -p "🔐 Do you want to encrypt the backup with a password? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🔐 Encrypting backup...${NC}"
    gpg --symmetric --cipher-algo AES256 "${BACKUP_NAME}"
    rm "${BACKUP_NAME}"
    echo -e "${GREEN}✅ Encrypted backup created: ${ENCRYPTED_BACKUP_NAME}${NC}"
    echo -e "${YELLOW}📊 Encrypted backup size: $(du -h "${ENCRYPTED_BACKUP_NAME}" | cut -f1)${NC}"
fi

echo -e "${GREEN}🎉 Backup completed successfully!${NC}"
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Store the backup file in a secure location (cloud storage, external drive)"
echo "2. Test the restore process in a safe environment"
echo "3. Document your domain and email settings for future reference"
echo ""
echo -e "${YELLOW}⚠️  Important:${NC}"
echo "- Keep your backup files secure and encrypted"
echo "- Store backup files in multiple locations"
echo "- Test restore process regularly"
echo "- Document your SWAG environment variables" 