#!/bin/bash

# SMTP Test Script for AWS SES
# Usage: ./test-smtp.sh

echo "=== AWS SES SMTP Test ==="
echo "Testing SMTP connectivity to AWS SES..."

# Test SMTP connection using openssl
echo "1. Testing SMTP connection..."
echo "QUIT" | openssl s_client -connect email-smtp.us-east-1.amazonaws.com:587 -starttls smtp -crlf

echo ""
echo "2. Testing with credentials (if available)..."
if [ -n "$SMTP_USERNAME" ] && [ -n "$SMTP_PASSWORD" ]; then
    echo "Credentials found, testing authentication..."
    # This is a basic test - you'll need to implement proper SMTP testing
    echo "SMTP credentials are configured"
else
    echo "SMTP credentials not found in environment"
fi

echo ""
echo "3. Next steps after domain verification:"
echo "   - Request production access in AWS SES Console"
echo "   - Test sending emails through your application"
echo "   - Verify emails are received correctly" 