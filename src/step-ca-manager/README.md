# 🔐 Step-CA Manager Stack

Complete SSL certificate management solution with private step-ca certificate authority and automatic ACME certificate generation.

## 📋 Description

Production-ready alternative to Let's Encrypt for internal infrastructure. Provides automatic SSL certificate management through step-ca with ACME protocol support and event-driven certificate generation.

## 🧩 Components

- **step-ca**: Private certificate authority with ACME provisioner 🏛️
- **step-ca-companion**: Custom nginxproxy/acme-companion with step-ca integration ⚡
- **nginx-proxy**: Reverse proxy with HTTP-01 challenge support 🔄

## ✨ Key Features

- **🏠 Private CA**: Complete control over certificate authority
- **⚡ Auto-Discovery**: Automatic step-ca detection and trust setup
- **🔄 Automatic Management**: No manual certificate handling required
- **🛡️ Trust Installation**: Automatic trust certificate deployment via step CLI
- **🚀 Production Ready**: Based on official nginxproxy/acme-companion

## ▶️ Quick Start

```bash
# Start the stack
docker-compose up -d

# Check logs
docker-compose logs -f step-ca-companion

# Verify certificates
docker-compose exec nginx-proxy ls -la /etc/nginx/certs/
```

## 🔧 Installing trusted certificate

### Automatic Installation with systemd (Recommended)

For automatic certificate installation and updates when step-ca container restarts or Docker context changes:

```bash
# Install user systemd integration (no sudo required)
./src/step-ca-companion/scripts/install-systemd-integration.sh

# Check status
./src/step-ca-companion/scripts/install-systemd-integration.sh status

# View logs
journalctl --user -u step-ca-monitor.service -f

# Remove integration
./src/step-ca-companion/scripts/install-systemd-integration.sh uninstall
```

**User Systemd Service Features:**

- **User-specific monitoring**: Monitors Docker contexts for current user only
- **Multi-level monitoring**: Docker Events + Context Changes (10s) + Periodic Container Check (30s)
- **User-context certificates**: Certificates named `step-ca-intermediate-<user>-<context>`
- **Group-based permissions**: Uses `step-ca-certs` group for secure certificate management
- **Cross-platform support**: Works on Ubuntu, Debian, Arch Linux, Fedora, RHEL

### One-time Installation (Alternative)

```bash
# Run the automated installation script once
./src/step-ca-companion/scripts/install-host-trust.sh

# With custom step-ca container name
STEP_CA_CONTAINER_NAME=my-step-ca ./src/step-ca-companion/scripts/install-host-trust.sh
```

### Manual Installation

```bash
# Get intermediate CA certificate
docker exec step-ca cat /home/step/certs/intermediate_ca.crt > intermediate.crt

# Ubuntu/Debian
sudo cp intermediate.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

# Arch Linux
sudo cp intermediate.crt /etc/ca-certificates/trust-source/anchors/
sudo trust extract-compat

# CentOS/RHEL/Fedora
sudo cp intermediate.crt /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust
```

## ⚙️ How it works

1. **step-ca** starts with ACME provisioner enabled
2. **step-ca-companion** auto-discovers step-ca and establishes trust via step CLI bootstrap
3. **nginx-proxy** handles HTTP-01 challenges and SSL termination
4. Certificates are automatically generated when containers start
5. Trust certificates are installed automatically during bootstrap
6. Automatic renewal happens according to acme-companion schedule

## ⚙️ Configuration

### Main Configuration

- **step-ca**: Configure via environment variables in docker-compose.yml
- **step-ca-companion**: See [step-ca-companion/README.md](src/step-ca-companion/README.md) for detailed configuration
- **nginx-proxy**: Standard nginx-proxy configuration

### Key Environment Variables

- `LETSENCRYPT_HOST`: Domains for certificate generation
- `LETSENCRYPT_EMAIL`: Email for certificate registration
- `STEP_CA_TRUST`: Enable trust certificate installation

For advanced configuration see [step-ca-companion documentation](src/step-ca-companion/README.md).

## 🌐 Remote Host Deployment

When deploying on a remote host where DNS client is not properly configured, additional DNS setup is required:

### Docker DNS Configuration

Add DNS configuration to Docker daemon on the host in `/etc/docker/daemon.json`:

```json
{
  "dns": ["${DNS_SERVER}", "8.8.8.8", "8.8.4.4"]
}
```

Replace `${DNS_SERVER}` with the actual IP address of your DNS server.

### Deployment with DNS Parameter

Run the deployment with DNS parameter:

```bash
./deploy.sh --dns
```

### ⚠️ Important Notes

- The `--config-file=/etc/docker/daemon.json` parameter may be missing from the Docker systemd service and needs to be added manually
- After modifying `/etc/docker/daemon.json`, restart Docker daemon: `sudo systemctl restart docker`
- Verify DNS configuration: `docker run --rm alpine nslookup your-domain.com`

### Systemd Service Configuration

If the Docker systemd service doesn't include the config file parameter, add it manually:

```ini
[Service]
ExecStart=/usr/bin/dockerd --config-file=/etc/docker/daemon.json
```

## 📚 Documentation

- **[step-ca-companion](src/step-ca-companion/README.md)**: Detailed documentation for the ACME companion
- **[docker-compose.yml](docker-compose.yml)**: Complete stack configuration
- **step-ca**: Official [smallstep documentation](https://smallstep.com/docs/)

## 📊 vs Let's Encrypt

| Feature | Let's Encrypt | step-ca |
|---------|---------------|---------|
| Trust | Automatic | Manual root cert install |
| Network | Internet required | Local only |
| Rate limits | Yes | No |
| Control | Limited | Full control |
