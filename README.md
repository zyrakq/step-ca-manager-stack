# 🐳 Docker Local Domain Stack

A technology stack for setting up local domain names in Docker with trusted certificates.

## 📦 Components

- **[step-ca-manager](app/)** - SSL certificate management with private CA and ACME protocol
- **[unbound](modules/unbound/)** - Local DNS resolver for custom domain names

## 🎯 Purpose

This stack enables you to:

- Use custom local domain names (e.g., `myapp.local`) in Docker containers
- Generate trusted SSL certificates automatically
- Avoid browser security warnings for local development

## 🚀 Quick Start

**Recommended setup order:**

1. **Start with [unbound](modules/unbound/)** - Set up local DNS resolution first
2. **Then configure [step-ca-manager](app/)** - Add SSL certificates for your domains
3. Follow the specific README instructions for each component

This order ensures you have working local domain resolution before adding SSL certificates.

## 📄 License

This project is dual-licensed under:

- [Apache License 2.0](LICENSE-APACHE)
- [MIT License](LICENSE-MIT)

You may choose either license for your use.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.
