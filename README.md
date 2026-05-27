# 📂 AutoProv — Cross-Platform Automated OS Provisioning Suite

**AutoProv** is a modular, enterprise-grade deployment suite designed to automate post-installation workflows for fresh operating system deployments. By bridging the gap between raw base images and production-ready environments, it eliminates manual infrastructure configuration, establishes instant security baselines, and deploys critical IT diagnostic packages in a single execution loop.

Built with a unified cross-platform strategy, AutoProv provides automated environments for both **Linux (Debian/Ubuntu)** and **Windows (10/11/Server)** endpoints.

---

## 🏗️ Repository Architecture

The suite is logically separated into decoupled environments to optimize system-specific tool deployments while sharing a unified layout:

```text
automated-os-provisioning/
├── linux/
│   ├── setup-deb.sh             # Main Debian/Ubuntu Bash engine
│   ├── custom_packages.list     # Admin-defined custom apt application manifest
│   └── README.md                # Linux usage & deployment documentation
├── windows/
│   ├── provision.ps1            # Main Windows PowerShell engine
│   ├── custom_packages.list     # Winget custom application manifest
│   └── README.md                # Windows usage & deployment documentation
├── CHANGELOG.md                 # Project versioning tracking (SemVer)
├── LICENSE                      # MIT Open-Source Compliance License
└── README.md                    # Main documentation landing page (This file)
