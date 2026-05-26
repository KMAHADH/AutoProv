# Changelog

All notable changes to the **AutoProv** deployment suite will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] - 2026-05-26

### Added
- **Dynamic Manifest Ingestion:** Introduced external parsing engine to read from `custom_packages.list` dynamically.
- **Ignore Tokens:** Added support for stripping out administrative comments (`#`) and trailing whitespaces from the package manifests during ingestion.
- **Comprehensive Logging:** Integrated robust logging pipeline pushing dual standard-out and physical log updates to `/var/log/autoprov.log`.

### Changed
- **Target Ecosystem Explicit File naming:** Renamed core execution framework script from `setup.sh` to `setup-deb.sh` to explicitly distinguish Debian-based environments.
- **Package Management Flow:** Upgraded execution array loop to handle silent fallback logging using subshell extraction strings.

---

## [1.0.0] - 2026-05-15

### Added
- **Initial Baseline Release:** Core setup utility suite configuration handling system automation for fresh OS installations.
- **IT Diagnostics Baseline:** Pre-loaded collection tracker array deploying fundamental network and terminal utilities (`nmap`, `htop`, `tmux`, `curl`, `net-tools`).
- **Idempotency Guard Checks:** Implemented native `dpkg -s` checks to prevent redundant package deployment over existing software.
- **Security Baseline:** Default state firewall initialization using standard Uncomplicated Firewall (`ufw`) configuration sets protecting external ingress.
- **Permissions Guardrail:** Implemented effective-user checking loops to safely force administrative/sudo execution blocks.
