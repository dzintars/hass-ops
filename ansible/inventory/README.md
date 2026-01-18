# Ansible Inventory Structure

This directory contains environment-specific inventories following Ansible best practices.

## Structure

```
inventory/
├── dev/                    # Development environment
│   ├── hosts.yaml         # Inventory file (localhost)
│   ├── group_vars/        # Group variables
│   │   └── all/          # Variables for all hosts
│   │       ├── ansible.yaml
│   │       └── vault.yaml (encrypted)
│   ├── host_vars/        # Host-specific variables
│   └── .ssh/             # SSH configuration (optional)
│       └── config
├── prod/                  # Production environment
│   ├── hosts.yaml        # Inventory file (remote hosts)
│   ├── group_vars/       # Group variables
│   │   └── all/
│   ├── host_vars/        # Host-specific variables
│   └── .ssh/             # SSH configuration (optional)
├── .ssh/                 # Shared SSH config (optional)
└── README.md             # This file
```

## Usage

### Development (Default)

The default inventory is `dev/` (configured in `ansible.cfg`):

```bash
cd ansible
ansible-playbook playbooks/setup-workstation.yml
```

### Production

To use the production inventory:

```bash
cd ansible
ansible-playbook playbooks/some-playbook.yml -i inventory/prod
```

Or update `ansible.cfg` to point to `inventory/prod`.

## Inventory Format

We use **YAML format** (`hosts.yaml`) for inventories with the following structure:

```yaml
---
all:
  children:
    group_name:
      hosts:
        hostname:
          ansible_host: 192.168.1.10
          ansible_user: ansible
```

## Variables Hierarchy

Variables are loaded in this order (last wins):

1. `inventory/dev/group_vars/all/*.yaml` - All hosts in dev
2. `inventory/dev/group_vars/group_name/*.yaml` - Specific group
3. `inventory/dev/host_vars/hostname/*.yaml` - Specific host

## SSH Configuration

Each environment can have its own SSH config:

- `inventory/dev/.ssh/config` - Dev SSH settings
- `inventory/prod/.ssh/config` - Prod SSH settings

Reference in `ansible.cfg`:
```ini
[ssh_connection]
ssh_args = -F ./inventory/dev/.ssh/config
```

## Verifying Inventory

```bash
# List all hosts
ansible-inventory --list

# List specific inventory
ansible-inventory -i inventory/prod --list

# Graph view
ansible-inventory --graph
```

## Best Practices

1. **Keep secrets encrypted**: Use `ansible-vault` for sensitive data
2. **Use group_vars**: Share common variables across hosts
3. **Use host_vars**: Override for specific hosts
4. **Version control**: Commit inventory structure, not secrets
5. **Document**: Add comments in YAML files
