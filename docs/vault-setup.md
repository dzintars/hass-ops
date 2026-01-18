# Vault Setup Guide

This guide explains how to set up password management using Ansible Vault and GNOME Keyring.

## Overview

Instead of entering your sudo password every time you run `make setup`, we store it encrypted in Ansible Vault, and retrieve the vault password from GNOME Keyring.

## Setup Steps

### 1. Install libsecret-tools

```bash
sudo dnf install libsecret-tools -y
```

### 2. Store Vault Password in Keyring (One-Time)

```bash
# This will prompt you to create a vault password
secret-tool store --label='Ansible Vault Password' ansible-vault hass-password

# Enter a strong password when prompted
# This password will be used to encrypt/decrypt your vault
```

### 3. Verify Keyring Storage

```bash
# This should print your vault password
secret-tool lookup ansible-vault hass-password
```

### 4. Create Encrypted Vault File

```bash
cd ansible

# Create and encrypt the vault file
# This will open your editor
ansible-vault create group_vars/all/vault.yml
```

Add the following content:

```yaml
---
# Encrypted become password
vault_ansible_become_pass: YOUR_SUDO_PASSWORD_HERE
```

Save and exit. The file will be automatically encrypted.

### 5. Verify Vault Configuration

```bash
# View encrypted file (will use keyring password)
ansible-vault view group_vars/all/vault.yml

# Edit encrypted file
ansible-vault edit group_vars/all/vault.yml
```

## Usage

Once configured, you can run:

```bash
make setup
```

No password prompts! The vault password comes from GNOME Keyring, and the become password comes from the encrypted vault.

## How It Works

```
make setup
    ↓
ansible-playbook (reads ansible.cfg)
    ↓
ansible.cfg → vault_password_file = ../scripts/ansible-vault-password.py
    ↓
ansible-vault-password.py → secret-tool lookup ansible-vault hass-password
    ↓
GNOME Keyring returns vault password
    ↓
Ansible decrypts group_vars/all/vault.yml
    ↓
vault_ansible_become_pass is available
    ↓
Playbook uses it for sudo operations
```

## Troubleshooting

### "secret-tool: command not found"

```bash
sudo dnf install libsecret-tools -y
```

### "Password not found in keyring"

```bash
# Store the password
secret-tool store --label='Ansible Vault Password' ansible-vault hass-password
```

### "ERROR! Attempting to decrypt but no vault secrets found"

```bash
# Make sure vault.yml is encrypted
cd ansible
ansible-vault encrypt group_vars/all/vault.yml
```

### "Incorrect vault password"

```bash
# Check keyring password
secret-tool lookup ansible-vault hass-password

# If wrong, delete and re-add
secret-tool clear ansible-vault hass-password
secret-tool store --label='Ansible Vault Password' ansible-vault hass-password
```

## Security Notes

- ✅ Vault password stored in GNOME Keyring (encrypted at rest)
- ✅ Become password encrypted with Ansible Vault
- ✅ No plaintext passwords in repository
- ✅ Keyring unlocked when you log in (seamless)

## Alternative: Manual Password Entry

If you don't want to use vault, you can still use manual password entry:

```bash
# Edit Makefile, change:
cd ansible && ansible-playbook playbooks/setup-workstation.yml

# To:
cd ansible && ansible-playbook playbooks/setup-workstation.yml --ask-become-pass
```

Then remove the `ansible_become_password` variable from the playbook.
