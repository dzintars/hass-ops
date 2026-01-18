# hass-ops

Infrastructure as Code for Home Assistant at scale

## Quick Start

### 1. Install Python and Ansible (Manual Step)

```bash
# Install Python and pip
sudo dnf install python3 python3-pip -y

# Install Ansible
pip3 install --user ansible
```

### 2. Install Build Prerequisites

```bash
# Clone the repository
git clone https://github.com/yourorg/hass-ops
cd hass-ops

# Install mkosi, make, KVM, QEMU, libvirt
make setup
```

### 3. Build Your First Image

```bash
# Build bootable Fedora 43 image
make build

# Test in QEMU/KVM
make test-vm
```

## Documentation

- [Quick Start Guide](docs/quickstart.md) - Detailed getting started instructions
- [Architecture](docs/architecture.md) - System architecture and design
- [Contributing](CONTRIBUTING.md) - How to contribute

## Available Commands

```bash
make help       # Show all available commands
make setup      # Install prerequisites (one-time)
make build      # Build bootable image
make test-vm    # Test image in QEMU
make clean      # Clean build artifacts
```

## Project Structure

```
hass-ops/
├── mkosi/              # Image builder configuration
├── ansible/            # Configuration management
│   ├── roles/
│   │   └── build-tools/   # Prerequisites installation
│   └── playbooks/
│       └── setup-workstation.yml
├── terraform/          # Infrastructure (future)
├── configs/            # Configuration files (future)
├── docs/              # Documentation
└── Makefile           # Build automation
```

## Requirements

- Fedora Linux (42 or 43)
- Python 3.9+
- Ansible 2.9+
- KVM-capable CPU (Intel VT-x or AMD-V)

## License

MIT License - see [LICENSE](LICENSE) for details

## Status

**Phase 1: Basic Image Building** ✅ In Progress
- [x] Repository structure
- [x] Ansible role for prerequisites
- [x] mkosi configuration for Fedora 43
- [x] Makefile automation
- [x] Documentation
- [ ] Testing and validation

**Phase 2: Stress Testing** 🔜 Coming Soon
- [ ] Stress testing tools integration
- [ ] Auto-run configuration
- [ ] Results collection

**Phase 3: Infrastructure** 🔜 Future
- [ ] PXE server deployment
- [ ] Central monitoring
- [ ] HASS at scale
