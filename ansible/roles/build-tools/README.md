# Build Tools Role

Ansible role to install build prerequisites for hass-ops.

## Description

This role installs and configures all necessary tools for building bootable images with hass-ops:

- **mkosi** - Image builder
- **make** - Build automation
- **qemu-kvm** - Virtualization with KVM acceleration
- **libvirt** - Virtual machine management
- **virt-manager** - GUI for managing VMs (optional)

## Requirements

- Fedora 42 or 43
- Ansible 2.9+
- Sudo privileges

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
build_tools_packages:
  - mkosi
  - make
  - qemu-kvm
  - libvirt
  - libvirt-daemon-kvm
  - virt-install
  - virt-manager

build_tools_services:
  - libvirtd

build_tools_user_groups:
  - libvirt
  - kvm
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - role: build-tools
```

## Post-Installation

After running this role, you may need to:

1. Log out and log back in for group changes to take effect
2. Verify KVM is available: `lsmod | grep kvm`
3. Test QEMU: `qemu-system-x86_64 --version`

## License

MIT

## Author

hass-ops contributors
