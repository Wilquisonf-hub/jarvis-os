#!/bin/bash
# deploy.sh — Promote staging file to production
# Usage: bash operations/deploy.sh <source-file>

set -e

if [ -z "$1" ]; then
    echo "Usage: bash operations/deploy.sh <source-file>"
    echo "Example: bash operations/deploy.sh tasks/pending.md"
    exit 1
fi

SOURCE="$1"
PROD_DIR="operations/production"
STAGING_DIR="operations/staging"

if [ ! -f "$SOURCE" ]; then
    echo "❌ Source file not found: $SOURCE"
    exit 1
fi

# Validate source before deploy
if [ ! -f "$STAGING_DIR" ]; then
    echo "❌ Staging directory not found"
    exit 1
fi

# Copy to production
cp "$SOURCE" "$PROD_DIR/"
echo "✅ Deployed: $SOURCE → $PROD_DIR/"

# Log the deploy
echo "| $(date +%Y-%m-%d_%H-%M) | deploy.sh | Deployed $SOURCE to production | COMPLETE |" >> operations/logs/change.log
