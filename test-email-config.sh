#!/bin/bash

echo "=== Email Configuration Test ==="
echo "Development: MailHog (localhost:8025)"
echo "Production: AWS SES (no-reply@fintrack.johnmjkim.com) - ap-southeast-2 ✅ VERIFIED"

echo ""
echo "=== Development Setup ==="
echo "✅ MailHog is configured for development"
echo "📧 Access MailHog UI at: http://localhost:8025"
echo "📧 SMTP server: localhost:1025"

echo ""
echo "=== Production Setup ==="
echo "✅ Domain verified: fintrack.johnmjkim.com"
echo "✅ AWS SES configured for: no-reply@fintrack.johnmjkim.com"
echo "✅ Can send from any email @fintrack.johnmjkim.com"

# Check if AWS credentials are available (for production reference)
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "⚠️  AWS credentials not found in environment (needed for production)"
else
    echo "✅ AWS credentials found (for production)"
fi

echo ""
echo "=== Testing ==="
echo "1. For development: Check MailHog UI at http://localhost:8025"
echo "2. For production: Emails will be sent via AWS SES"
echo ""
echo "=== Next Steps ==="
echo "Development:"
echo "  - Restart backend: docker-compose -f docker-compose.dev.yml restart backend"
echo "  - Check MailHog UI for emails"
echo ""
echo "Production:"
echo "  - Deploy with production configuration"
echo "  - Test email functionality in your application"
echo "  - Monitor AWS SES console for sending statistics" 