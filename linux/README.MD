# 🐧 AutoProv — Linux Provisioning Engine (Debian/Ubuntu)

This component of the **AutoProv** suite automates post-installation workflows, software deployment, and security baseline configurations for Debian-based Linux environments. It is optimized for rapidly setting up bare-metal servers, development workstations, and headless infrastructure (such as Raspberry Pi environments).

---

## 📦 Core IT Support Toolkit Deployed


> ⚠️ **Security Best Practice:** Always review external provisioning scripts and configuration manifests before executing them with elevated privileges on live administrative infrastructure.

By default, executing `setup-deb.sh` syncs local package repositories, applies core OS security upgrades, and deploys the following system diagnostics baseline:

| Package | Utility Classification | Core IT Use Case |
| :--- | :--- | :--- |
| **`nmap`** | Network Discovery | Port auditing, asset discovery, and network mapping |
| **`htop`** | Resource Management | Real-time interactive process viewer and system vital monitoring |
| **`tmux`** | Terminal Multiplexer | Persistent terminal sessions for remote headless operations |
| **`net-tools`** | Networking Legacy | Traditional network diagnostic utilities (`ifconfig`, `netstat`) |
| **`curl` / `git`** | Data & Version Control | Secure data transfer pipelines and repository management |
| **`ufw`** | Firewall Security | Uncomplicated Firewall layer to secure local ingress boundaries |

---

## 🚀 Deployment Instructions

### 1. Prerequisites
* **Target OS:** Ubuntu (Server/Desktop), Debian, Mint, or Raspberry Pi OS.
* **Privileges:** Root access or an account registered within the local `sudo` group.
* **Permissions:** Makethe script have executable permssions with "chmod +x".

### 2. (Optional) Injecting Custom Application Manifests
Before running the main script, you can define a custom list of additional software packages you want to install by editing `custom_packages.list` in this directory. 

* Place exactly one package name per line (must match the standard `apt` package manager naming syntax).
* You can add administrative notes or group headers by starting lines with a `#` token.

**Example `custom_packages.list`:**
```text
# --- Admin Utility Additions ---
neofetch
traceroute
iperf3

# --- Runtime Libraries ---
build-essential
