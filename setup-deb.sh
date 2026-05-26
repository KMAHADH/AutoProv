#!/usr/bin/env bash
# ================================================================================================
# Script Name   : setup-deb.sh (Part of AutoProv)
# Description   : Automates post-install configurations & tools deployment for deb-based systems
# Author        : Khwaja Mahad Haq
# ================================================================================================

# Exit immediately if a command fails, or if an uninitialized variable is used
set -euo pipefail

# --- Color Palettes for Clean Terminal Output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Configuration & Log Paths ---
LOG_FILE="/var/log/autoprov.log"
CUSTOM_LIST_NAME="custom_packages.list"
# Dynamically locate the custom list relative to where this script is saved
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_LIST_PATH="$SCRIPT_DIR/$CUSTOM_LIST_NAME"

# --- Helper Functions ---
log_info() {
    echo -e "${GREEN}[INFO] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR] $(date +'%Y-%m-%d %H:%M:%S') - $1${NC}" | tee -a "$LOG_FILE"
}

# --- Root Permission Guard ---
if [ "$EUID" -ne 0 ]; then
    log_error "This provisioning script must be run as root or with sudo privileges."
    exit 1
fi

# --- Clear Screen and Banner Display ---
clear
echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}        AutoProv v1.1 — Linux Post-Install Suite    ${NC}"
echo -e "${BLUE}====================================================${NC}"
log_info "Initialization started. Logging active output to: $LOG_FILE"

# --- Phase 1: System Patching & Repository Sync ---
echo ""
log_info "Phase 1: Syncing package lists and upgrading core OS dependencies..."
apt-get update -y && apt-get upgrade -y

# --- Phase 2: Deploying IT Support Utilities ---
echo ""
log_info "Phase 2: Installing core IT networking & troubleshooting packages..."

# Core internal system package array
CORE_PACKAGES=(
    "curl"
    "git"
    "htop"       # Interactive process viewer
    "nmap"       # Network exploration tool
    "tmux"       # Terminal multiplexer
    "net-tools"  # Legacy networking utilities
    "ufw"        # Uncomplicated Firewall
)

# ─── NEW FEATURE: CUSTOM PACKAGE INGESTION ───
FINAL_PACKAGES=("${CORE_PACKAGES[@]}")

if [ -f "$CUSTOM_LIST_PATH" ]; then
    log_info "Detected external manifest file: $CUSTOM_LIST_NAME"
    
    # Read file line-by-line: ignoring empty lines and comments starting with '#'
    while IFS= read -r line || [ -n "$line" ]; do
        # Strip leading/trailing whitespaces
        cleaned_line=$(echo "$line" | xargs)
        
        # Skip if line is empty or starts with a comment token
        if [ -z "$cleaned_line" ] || [[ "$cleaned_line" == \#* ]]; then
            continue
        fi
        
        FINAL_PACKAGES+=("$cleaned_line")
        log_info "Added custom package to queue: $cleaned_line"
    done < "$CUSTOM_LIST_PATH"
else
    log_warn "No custom package manifest found at $CUSTOM_LIST_PATH. Proceeding with core defaults only."
fi

# ─── PROCESS DRIVER ARRAY INSTALLATION ───
echo ""
log_info "Executing unified package deployment sequence..."
for PACKAGE in "${FINAL_PACKAGES[@]}"; do
    if dpkg -s "$PACKAGE" >/dev/null 2>&1; then
        log_warn "Package '$PACKAGE' is already present. Skipping installation."
    else
        log_info "Deploying package: $PACKAGE"
        # Using a subshell string expansion to handle error conditions cleanly
        if apt-get install -y "$PACKAGE" >> "$LOG_FILE" 2>&1; then
            log_info "Successfully installed: $PACKAGE"
        else
            log_error "Failed to install package: $PACKAGE. Check $LOG_FILE for details."
        fi
    fi
done

# --- Phase 3: Basic Security Baseline ---
echo ""
log_info "Phase 3: Deploying a security baseline config..."

if systemctl is-active --quiet ufw; then
    log_warn "Firewall configuration (ufw) is already active."
else
    log_info "Enabling UFW and configuring standard rules (allowing SSH connection updates)..."
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    echo "y" | ufw enable
fi

# --- Execution Summary ---
echo ""
echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}    [✓] AutoProv System Setup Completed Successfully! ${NC}"
echo -e "${GREEN}====================================================${NC}"
log_info "Provisioning process complete. System status: READY."
