#!/bin/bash
set -euo pipefail

# ================================
# Load environment variables from env.groovy automatically
# ================================
ENV_FILE="env.groovy"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "❌ $ENV_FILE not found! Please create it with NEXUS_URL, NEXUS_USER, NEXUS_PASS."
    exit 1
fi

# ================================
# Validate required variables
# ================================
: "${NEXUS_URL:?Please set NEXUS_URL in $ENV_FILE}"
: "${NEXUS_USER:?Please set NEXUS_USER in $ENV_FILE}"
: "${NEXUS_PASS:?Please set NEXUS_PASS in $ENV_FILE}"

UBUNTU_REPO="ubuntu-hosted"
CENTOS_REPO="centos-hosted"
PKG_DIR="./packages"

# ================================
# Setup logging
# ================================
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/upload_$(date +%Y%m%d_%H%M%S).log"

echo "=== Starting Nexus Upload ===" | tee -a "$LOG_FILE"

# ================================
# Function to upload files
# ================================
upload_file() {
    local file=$1
    local repo=$2
    local basename=$(basename "$file")
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Uploading $basename to $repo..." | tee -a "$LOG_FILE"
    
    HTTP_CODE=$(curl -s -w "%{http_code}" -u "$NEXUS_USER:$NEXUS_PASS" --upload-file "$file" \
        "$NEXUS_URL/$repo/$basename" -o /dev/null)
    
    if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
        echo "✅ $basename uploaded successfully." | tee -a "$LOG_FILE"
    else
        echo "❌ Failed to upload $basename (HTTP $HTTP_CODE)" | tee -a "$LOG_FILE"
    fi
}

# ================================
# Upload DEB packages (Ubuntu)
# ================================
for deb in "$PKG_DIR"/*.deb; do
    [ -f "$deb" ] || continue
    upload_file "$deb" "$UBUNTU_REPO"
done

# ================================
# Upload RPM packages (CentOS)
# ================================
for rpm in "$PKG_DIR"/*.rpm; do
    [ -f "$rpm" ] || continue
    upload_file "$rpm" "$CENTOS_REPO"
done

echo "=== Nexus Upload Completed ===" | tee -a "$LOG_FILE"
