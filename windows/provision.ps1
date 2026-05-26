<#
.SYNOPSIS
    provision.ps1 (Part of AutoProv)
.DESCRIPTION
    Automates post-install configurations & core IT tools deployment for Windows endpoints.
.AUTHOR
    Khwaja Mahad Haq
#>

# Enforce strict error handling: Stop execution immediately on hard errors
$ErrorActionPreference = "Stop"

# --- Configuration & Log Paths ---
$LogFile = "C:\Windows\Temp\autoprov.log"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CustomListPath = Join-Path $ScriptDir "custom_packages.list"

# --- Helper Logging Functions ---
function Log-Info ($Message) {
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[INFO] $TimeStamp - $Message" | Out-File -FilePath $LogFile -Append -Encoding utf8
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Log-Warn ($Message) {
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[WARN] $TimeStamp - $Message" | Out-File -FilePath $LogFile -Append -Encoding utf8
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Log-Error ($Message) {
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[ERROR] $TimeStamp - $Message" | Out-File -FilePath $LogFile -Append -Encoding utf8
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# --- Administrative Privilege Guard ---
$CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Log-Error "This provisioning script must be run inside an elevated PowerShell terminal (Run as Administrator)."
    Exit 1
}

# --- Initialization & Clear Window ---
Clear-Host
Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host "        AutoProv v1.1 — Windows Post-Install Suite  " -ForegroundColor Cyan
Write-Host "==============================================================" -ForegroundColor Cyan
Log-Info "Initialization started. Logging active output to: $LogFile"

# --- Phase 1: Verify Windows Package Manager (Winget) ---
Log-Info "Phase 1: Validating Windows Package Manager (Winget) availability..."
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Log-Error "Winget is missing on this endpoint. Please update the App Installer framework before proceeding."
    Exit 1
}

# --- Phase 2: Core IT Support Utilities Array ---
Log-Info "Phase 2: Compiling package deployment queue..."

# Array of standard corporate IT tools (Winget App IDs)
$CorePackages = @(
    "Git.Git"
    "7zip.7zip"
    "Sysinternals.Suite"       # Essential deep troubleshooting utilities
    "Wireshark.Wireshark"       # Packet analyzer
    "Nmap.Nmap"                 # Network discovery mapper
    "PuTTY.PuTTY"               # SSH/Telnet terminal client
)

$FinalPackages = @() + $CorePackages

# ─── CUSTOM PACKAGE INGESTION ───
if (Test-Path $CustomListPath) {
    Log-Info "Detected external manifest file: custom_packages.list"
    
    # Read text file line by line, filtering out empty entries and lines starting with '#'
    Get-Content $CustomListPath | ForEach-Object {
        $CleanedLine = $_.Trim()
        if ($CleanedLine -and -not $CleanedLine.StartsWith("#")) {
            $FinalPackages += $CleanedLine
            Log-Info "Added custom package to queue: $CleanedLine"
        }
    }
} else {
    Log-Warn "No custom package manifest found at $CustomListPath. Proceeding with core defaults only."
}

# ─── UNIFIED EXECUTION SEQUENCE ───
Log-Info "Executing package deployment sequence via Winget..."

foreach ($Package in $FinalPackages) {
    # Check if the tool is already registered on the system
    $CheckInstalled = winget list --id $Package --accept-source-agreements -e ErrorAction SilentlyContinue
    
    if ($CheckInstalled) {
        Log-Warn "Package '$Package' is already present. Skipping installation."
    } else {
        Log-Info "Deploying package: $Package"
        try {
            # --silent installs application in background; --accept-package-agreements bypasses user prompts
            winget install --id $Package --silent --accept-package-agreements --accept-source-agreements | Out-File -FilePath $LogFile -Append
            Log-Info "Successfully installed: $Package"
        } catch {
            Log-Error "Failed to deploy package: $Package. Check details in $LogFile"
        }
    }
}

# --- Phase 3: Basic Security Baseline ---
Log-Info "Phase 3: Hardening system baseline configurations..."

# Example: Enforce TLS 1.2/1.3 and ensure standard Windows Firewall profiles are enabled
try {
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
    Log-Info "Windows Firewall profiles successfully validated and enabled across all interfaces."
} catch {
    Log-Warn "Could not modify Firewall configurations. Please inspect permissions."
}

# --- Execution Summary ---
Write-Host ""
Write-Host "=========================================================" -ForegroundColor Green
Write-Host "    [✓] AutoProv Windows Setup Completed Successfully! " -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green
Log-Info "Provisioning process complete. Endpoint state: READY."
