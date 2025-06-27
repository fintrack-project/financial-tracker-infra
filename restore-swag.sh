#!/bin/bash

# SWAG Restore Script
# This script restores SWAG configuration and certificates from backup
# Run this script from the financial-tracker-infra directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔄 SWAG Restore Script${NC}"
echo "=================================="

# Check if backup file is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Usage: $0 <backup-file.tar.gz>${NC}"
    echo "Example: $0 swag-backup-20241227_143022.tar.gz"
    exit 1
fi

BACKUP_FILE="$1"
RESTORE_DIR="./swag-restore"

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${RED}❌ Backup file not found: $BACKUP_FILE${NC}"
    exit 1
fi

# Check if SWAG container is running
if ! docker ps | grep -q swag; then
    echo -e "${RED}❌ SWAG container is not running. Please start it first.${NC}"
    exit 1
fi

echo -e "${YELLOW}📁 Creating restore directory...${NC}"
mkdir -p "${RESTORE_DIR}"

# Extract backup
echo -e "${YELLOW}📦 Extracting backup...${NC}"
tar -xzf "${BACKUP_FILE}" -C "${RESTORE_DIR}"

# Verify backup contents
if [ ! -d "${RESTORE_DIR}/keys" ] || [ ! -d "${RESTORE_DIR}/site-confs" ]; then
    echo -e "${RED}❌ Invalid backup file. Missing required directories.${NC}"
    rm -rf "${RESTORE_DIR}"
    exit 1
fi

echo -e "${YELLOW}🔒 Restoring SSL certificates and keys...${NC}"
docker cp "${RESTORE_DIR}/keys" swag:/config/

echo -e "${YELLOW}📝 Restoring custom nginx configurations...${NC}"
docker cp "${RESTORE_DIR}/site-confs" swag:/config/nginx/

# Show environment variables for reference
if [ -f "${RESTORE_DIR}/swag-env.txt" ]; then
    echo -e "${YELLOW}⚙️  Backup environment variables:${NC}"
    cat "${RESTORE_DIR}/swag-env.txt"
    echo ""
    echo -e "${YELLOW}⚠️  Please verify these match your current SWAG environment variables${NC}"
fi

# Clean up
rm -rf "${RESTORE_DIR}"

# Reload nginx
echo -e "${YELLOW}🔄 Reloading nginx configuration...${NC}"
docker exec swag nginx -t
docker exec swag nginx -s reload

echo -e "${GREEN}✅ Restore completed successfully!${NC}"
echo ""
echo -e "${YELLOW}📋 Verification steps:${NC}"
echo "1. Check if SSL certificates are working: https://fintrack.johnmjkim.com"
echo "2. Verify nginx configuration: docker exec swag nginx -t"
echo "3. Check SWAG logs: docker logs swag"
echo ""
echo -e "${YELLOW}⚠️  Important:${NC}"
echo "- If certificates are expired, SWAG will automatically renew them"
echo "- You may need to restart the SWAG container if there are issues"
echo "- Verify your domain DNS settings are still correct" 