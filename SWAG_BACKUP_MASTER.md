# 🔐 SWAG Backup & Restore Master Guide

**Last Updated**: December 27, 2024  
**Domain**: fintrack.johnmjkim.com  
**Status**: ✅ Production Ready

---

## 🚀 Quick Start

### Create Your First Backup
```bash
# Make sure SWAG is running
docker-compose -f docker-compose.prod.yml up -d swag

# Create encrypted backup
./backup-swag.sh
```

### Restore from Backup
```bash
# Restore from backup file
./restore-swag.sh swag-backup-YYYYMMDD_HHMMSS.tar.gz
```

---

## 📋 What Gets Backed Up

### ✅ Critical Files (Always Backup)
- **SSL Certificates & Keys**: `/swag/keys/` - Let's Encrypt certificates and private keys
- **Custom Nginx Configs**: `/swag/config/nginx/site-confs/` - Your custom domain configurations
- **Environment Variables**: SWAG container environment settings
- **Container Configuration**: Docker container inspection data

### ❌ Files NOT Backed Up (Can be Regenerated)
- **Logs**: `/swag/log/` - Application and nginx logs
- **Temporary Files**: Cache directories and temporary files
- **Default Configs**: SWAG can regenerate these automatically

---

## 🌐 Current Configuration

### Domain Configuration
- **Domain**: fintrack.johnmjkim.com
- **IP Address**: 220.233.25.14
- **DNS Provider**: Cloudflare
- **SSL**: Let's Encrypt (Auto-renewal enabled)

### DNS Records
```
Type: A
Name: fintrack.johnmjkim.com
Value: 220.233.25.14
Proxy: Enabled (Orange Cloud)
```

### SWAG Environment Variables
```bash
PUID=1000
PGID=1000
TZ=UTC
URL=johnmjkim.com
SUBDOMAINS=fintrack
VALIDATION=http
STAGING=true
EMAIL=admin@johnmjkim.com
```

### Key Settings
- **Domain**: johnmjkim.com
- **Subdomains**: fintrack
- **Email**: admin@johnmjkim.com
- **Validation**: HTTP (port 80)
- **Staging**: true (using Let's Encrypt staging for testing)

### Critical Files
- **SSL Certificates**: `/swag/keys/letsencrypt/`
  - `fullchain.pem` - Full certificate chain
  - `privkey.pem` - Private key
  - `chain.pem` - Intermediate certificates
- **Custom Nginx Configs**: `/swag/config/nginx/site-confs/`
  - `fintrack.johnmjkim.com.conf` - Main domain configuration
  - `default.conf` - Default catch-all configuration

---

## 🔐 Security Features

- **Encryption**: Optional GPG AES256 encryption
- **Selective Backup**: Only critical files, not logs or temp files
- **Verification**: Scripts verify backup integrity
- **Safe Storage**: Recommendations for secure storage locations

---

## 📝 Manual Backup Process

If you prefer to backup manually:

### 1. Backup SSL Certificates
```bash
# Create backup directory
mkdir -p swag-backup

# Backup SSL certificates and keys
docker cp swag:/config/keys swag-backup/
```

### 2. Backup Custom Configurations
```bash
# Backup custom nginx configurations
docker cp swag:/config/nginx/site-confs swag-backup/
```

### 3. Backup Environment Variables
```bash
# Export environment variables
docker inspect swag --format='{{range .Config.Env}}{{println .}}{{end}}' > swag-backup/swag-env.txt
```

### 4. Create Archive
```bash
# Create compressed archive
tar -czf swag-backup-$(date +%Y%m%d_%H%M%S).tar.gz -C swag-backup .

# Clean up
rm -rf swag-backup
```

---

## 🔐 Security Best Practices

### 1. Encrypt Your Backups
```bash
# Encrypt backup with GPG
gpg --symmetric --cipher-algo AES256 swag-backup-20241227_143022.tar.gz
```

### 2. Store Securely
- **Cloud Storage**: Google Drive, Dropbox, or AWS S3 (encrypted)
- **External Drive**: Encrypted USB drive
- **Multiple Locations**: Don't rely on a single backup location

### 3. Regular Backups
- **Frequency**: Monthly or after significant changes
- **Retention**: Keep at least 3 recent backups
- **Testing**: Test restore process quarterly

---

## 🔄 Restore Process

### 1. Extract Backup
```bash
# Extract backup archive
tar -xzf swag-backup-20241227_143022.tar.gz -C swag-restore
```

### 2. Restore Files
```bash
# Restore SSL certificates
docker cp swag-restore/keys swag:/config/

# Restore nginx configurations
docker cp swag-restore/site-confs swag:/config/nginx/
```

### 3. Reload Configuration
```bash
# Test nginx configuration
docker exec swag nginx -t

# Reload nginx
docker exec swag nginx -s reload
```

---

## 📋 Quick Commands

### Check SSL Certificate
```bash
# Check certificate expiration
docker exec swag openssl x509 -in /config/keys/letsencrypt/fullchain.pem -text -noout | grep -A 2 "Validity"

# Check certificate validity
docker exec swag openssl x509 -in /config/keys/letsencrypt/fullchain.pem -checkend 86400 -noout
```

### Check Nginx Configuration
```bash
# Test nginx configuration
docker exec swag nginx -t

# Reload nginx configuration
docker exec swag nginx -s reload
```

### View Logs
```bash
# SWAG container logs
docker logs swag

# Nginx access logs
docker exec swag tail -f /config/log/nginx/access.log

# Nginx error logs
docker exec swag tail -f /config/log/nginx/error.log
```

---

## 📅 Recommended Schedule

- **Monthly**: Full encrypted backup
- **After Changes**: Backup after any SWAG configuration changes
- **Quarterly**: Test restore process
- **Before Updates**: Backup before major system updates

---

## 🚨 Emergency Recovery

If you lose your server or need to restore:

1. **Clone your repo**: `git clone <your-repo>`
2. **Start SWAG**: `docker-compose -f docker-compose.prod.yml up -d swag`
3. **Restore backup**: `./restore-swag.sh <backup-file>`
4. **Verify**: Check SSL certificates and nginx configuration

### Complete Server Loss
1. **Restore SWAG Backup**: Use the restore script
2. **Verify DNS**: Ensure domain points to new server IP
3. **Update Firewall**: Open ports 80 and 443
4. **Test SSL**: Check certificate validity

### Certificate Issues
1. **Check Expiration**: `docker exec swag openssl x509 -in /config/keys/letsencrypt/fullchain.pem -text -noout`
2. **Force Renewal**: Restart SWAG container
3. **Manual Renewal**: If needed, delete certificates and restart

---

## ⚠️ Important Notes

### SSL Certificate Renewal
- **Automatic**: SWAG automatically renews certificates before expiration
- **Manual**: If certificates are expired, SWAG will renew them on next restart
- **Rate Limits**: Let's Encrypt has rate limits (5 per domain per week)

### Security Considerations
- **Private Keys**: Never expose private keys
- **Backup Encryption**: Always encrypt backups
- **Access Control**: Limit access to SWAG configuration
- **Monitoring**: Monitor certificate expiration

### Disaster Recovery
1. **Server Loss**: Restore from backup, update DNS
2. **Certificate Issues**: Restart SWAG container
3. **Configuration Errors**: Check nginx syntax, restore from backup

---

## 🔧 Production Checklist

### Before Going Live
- [ ] Change `STAGING=true` to `STAGING=false` in docker-compose.prod.yml
- [ ] Verify DNS records are correct
- [ ] Test SSL certificate generation
- [ ] Create initial backup
- [ ] Test restore process

### Regular Maintenance
- [ ] Monthly backup creation
- [ ] Quarterly restore testing
- [ ] Monitor certificate expiration
- [ ] Update documentation

---

## 📞 Troubleshooting

### Common Issues
- **Certificate Expired**: Restart SWAG container
- **Nginx Config Error**: Check syntax with `docker exec swag nginx -t`
- **Permission Issues**: Ensure proper file ownership in container

### Logs
```bash
# SWAG logs
docker logs swag

# Nginx logs
docker exec swag tail -f /config/log/nginx/access.log
docker exec swag tail -f /config/log/nginx/error.log
```

---

## 🚨 Emergency Contacts

### Domain Management
- **Registrar**: (Your domain registrar)
- **DNS Provider**: Cloudflare
- **SSL Provider**: Let's Encrypt

### Server Access
- **IP**: 220.233.25.14
- **SSH**: (Your SSH access method)
- **Docker**: Running on local machine

---

## 📁 Files Included

### Scripts
- `backup-swag.sh` - Automated backup script
- `restore-swag.sh` - Automated restore script

### Documentation
- `SWAG_BACKUP_MASTER.md` - This comprehensive guide

---

**Remember**: Your SSL certificates are critical for your application's security. Always keep multiple secure backups and test your restore process regularly. 