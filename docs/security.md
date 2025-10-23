# Raspberry Pi Security Guidance

Adding any Raspberry Pi to your network can introduce security weaknesses. You are advised to consider taking some or all of these suggestions as appropriate for your environment

## Authentication & Access Control

- **Change all default passwords** immediately, especially for the default `pi` user (or remove this account entirely)
- **Use strong, unique passwords** for all user accounts (minimum 12 characters with mixed case, numbers, and symbols)
- **Disable password authentication for SSH** and use key-based authentication only
- **Add authentication to all web interfaces** and services (Node-RED, Home Assistant, etc.)
- **Use `sudo` judiciously** - avoid running as root unnecessarily
- **Create separate user accounts** for different purposes rather than sharing accounts

## SSH Hardening

- **Disable root login via SSH** (`PermitRootLogin no` in `/etc/ssh/sshd_config`)
- **Use SSH keys only** (`PasswordAuthentication no`)
- **Change the default SSH port** from 22 to reduce automated attacks (optional but helpful)
- **Limit SSH access to specific users** (`AllowUsers username`)
- **Consider fail2ban** to automatically block IPs after failed login attempts
- **Disable SSH entirely** if you don't need remote access

## System Updates & Maintenance

- **Keep your system updated**: Run `sudo apt update && sudo apt upgrade` regularly
- **Enable automatic security updates** for critical patches
- **Remove unused packages and services** to reduce attack surface
- **Update firmware** with `sudo rpi-update` when necessary

## Network Security

- **Configure a firewall** using UFW or iptables to block unnecessary ports
- **Disable unused network services** (Bluetooth, WiFi if using ethernet, etc.)
- **Use a VPN** for remote access instead of exposing SSH to the internet
- **Change your WiFi password** if using wireless connectivity
- **Place your Pi on a separate VLAN** if running IoT or untrusted services
- **Disable IPv6** if you're not using it

## Physical Security

- **Secure physical access** to the device - it's easy to extract data from an SD card
- **Consider encrypting the root filesystem** for sensitive applications
- **Disable USB booting** if not needed (`program_usb_boot_mode=0`)

## Service Management

- **Disable unnecessary services** on boot (VNC, serial console, etc.)
- **Run services with minimal privileges** (use dedicated users, not root)
- **Keep exposed services updated** and properly configured
- **Use reverse proxies** (like Nginx) with SSL/TLS for web services

## Monitoring & Logging

- **Enable and review logs** regularly (`/var/log/auth.log` for authentication attempts)
- **Set up log monitoring** with tools like Logwatch
- **Consider intrusion detection** (AIDE, rkhunter) for critical systems
- **Monitor system resources** for unusual activity

## Additional Best Practices

- **Back up your SD card** regularly - security incidents are easier to recover from with backups
- **Use read-only filesystem** for kiosk or dedicated-purpose devices
- **Implement rate limiting** on publicly accessible services
- **Document your configuration** so you can audit and replicate security settings
- **Test your security** periodically with tools like nmap and Lynis

---

> [!NOTE]
> The specific measures you implement should depend on your use case - a home media server needs different security than an internet-facing web server or an industrial control system.