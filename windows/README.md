# 🪟 AutoProv — Windows Provisioning Engine

This component of the **AutoProv** suite leverages the native **Windows Package Manager (Winget)** and modern PowerShell scripting to automate post-installation software deployment, system updates, and basic security baseline configurations. It is optimized for rapidly setting up corporate workstations, enterprise IT endpoints, and Windows Server infrastructure.

---

## 📦 Core IT Support Toolkit Deployed

> ⚠️ **Security Best Practice:** Always review external PowerShell scripts and configuration manifests inside an isolated testing environment before executing them with elevated administrative privileges on live production infrastructure.

By default, executing `provision.ps1` calls the Winget API to silently fetch and deploy the following industry-standard IT toolkit:

| Package ID | Utility Classification | Core IT Use Case |
| :--- | :--- | :--- |
| **`Sysinternals.Suite`** | System Diagnostics | Deep-dive administrative monitoring, process tracking (`ProcMon`), and troubleshooting |
| **`Wireshark.Wireshark`** | Network Analysis | Real-time packet capture, network analysis, and frame auditing |
| **`Nmap.Nmap`** | Network Discovery | Port scanning, vulnerability scanning, and local asset mapping |
| **`PuTTY.PuTTY`** | Secure Shell Client | Standard SSH/Telnet client for managing headless networking equipment and Linux nodes |
| **`7zip.7zip`** | Archive Management | High-performance data compression and system archive extraction |
| **`Git.Git`** | Version Control | Version control engine and decentralized codebase deployment |

---

## 🚀 Deployment Instructions

### 1. Prerequisites
* **Target OS:** Windows 10 (Build 1809 or later), Windows 11, or Windows Server 2022.
* **Framework:** The native **Winget** client (packaged with modern *App Installer* framework builds) must be present and fully updated.
* **Privileges:** The terminal window must be launched with elevated administrative permissions.

### 2. (Optional) Injecting Custom Application Manifests
Before executing the script, you can define a custom list of additional applications to install by editing `custom_packages.list` in this directory. 

* Place exactly one application **Winget ID** per line. (You can locate IDs using the command `winget search <app-name>`).
* You can add notes or group headers by starting lines with a `#` token.

**Example `custom_packages.list`:**
```text
# --- Productivity & IDE Additions ---
Microsoft.VisualStudioCode
Google.Chrome

# --- System Utilities ---
AgileBits.1Password
