# Quick Start Guide

## Prerequisites

Before you can use hass-ops, you need to install Python and Ansible on your workstation.

### Step 1: Install Python (if not already installed)

```bash
# Check if Python is installed
python3 --version

# If not installed, install Python 3
sudo dnf install python3 python3-pip -y
```

### Step 2: Install Ansible

```bash
# Install Ansible using pip
pip3 install --user ansible

# Verify installation
ansible --version
```

### Step 3: Configure Vault (Optional but Recommended)

To avoid entering your sudo password every time, set up Ansible Vault with GNOME Keyring:

```bash
# Install secret-tool
sudo dnf install libsecret-tools -y

# Store vault password in keyring
secret-tool store --label='Ansible Vault Password' ansible-vault hass-password

# Create encrypted vault file with your sudo password
cd ansible
ansible-vault create group_vars/all/vault.yml
# Add: vault_ansible_become_pass: YOUR_SUDO_PASSWORD
```

See [Vault Setup Guide](vault-setup.md) for detailed instructions.

### Step 4: Install Build Prerequisites

Now that Ansible is installed, run the setup playbook to install all build tools:

```bash
cd /path/to/hass-ops

# Install mkosi, make, KVM, QEMU, libvirt
make setup
```

This will install:
- `mkosi` - Image builder
- `make` - Build automation
- `qemu-kvm` - Virtualization with KVM acceleration
- `libvirt` - Virtual machine management
- `virt-manager` - (Optional) GUI for managing VMs

## Building Your First Image

### 1. Build the bootable image

```bash
make build
```

This will:
- Use mkosi to build a Fedora 43 base image
- Create a bootable disk image
- Output to `mkosi.output/image.raw`

### 2. Test in a virtual machine

```bash
make test-vm
```

This will boot the image in QEMU/KVM for testing.

### 3. (Future) Write to USB drive

```bash
# WARNING: This will erase the USB drive!
make write-usb DEVICE=/dev/sdb
```

## Troubleshooting

### "ansible: command not found"

Make sure `~/.local/bin` is in your PATH:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### "KVM not available"

Verify KVM is enabled:

```bash
# Check if KVM module is loaded
lsmod | grep kvm

# If not, load it
sudo modprobe kvm
sudo modprobe kvm_intel  # or kvm_amd for AMD CPUs
```

### "Permission denied" when accessing /dev/kvm

Add your user to the `libvirt` group:

```bash
sudo usermod -a -G libvirt $USER
# Log out and log back in for changes to take effect
```

## Next Steps

- Customize the image configuration in `mkosi/mkosi.conf`
- Add stress testing tools (coming soon)
- Deploy PXE server for network booting (coming soon)

## Getting Help

- Check the [Architecture Documentation](architecture.md)
- Review the [Makefile](../Makefile) for available commands
- Open an issue on GitHub
