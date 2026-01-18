#!/bin/bash
# Quick vault setup script
set -euo pipefail

echo "=== Ansible Vault Setup ==="
echo ""

# Check if secret-tool is installed
if ! command -v secret-tool &> /dev/null; then
    echo "Installing libsecret-tools..."
    sudo dnf install libsecret-tools -y
fi

# Store vault password in keyring
echo "Step 1: Store vault password in GNOME Keyring"
echo "You'll be prompted to create a vault password (used to encrypt/decrypt vault files)"
if ! secret-tool store --label='Ansible Vault Password' ansible-vault hass-password; then
    echo "Error: Failed to store password in keyring" >&2
    exit 1
fi

# Verify it's stored
echo ""
echo "✓ Vault password stored in keyring"
echo ""

# Prompt for sudo password
echo "Step 2: Enter your sudo password (will be encrypted)"
read -r -s -p "Sudo password: " SUDO_PASS
echo ""

if [ -z "$SUDO_PASS" ]; then
    echo "Error: Password cannot be empty" >&2
    exit 1
fi

# Create encrypted vault file
cd ansible || exit 1

cat > group_vars/all/vault.yml.tmp << EOF
---
# Encrypted become password
vault_ansible_become_pass: ${SUDO_PASS}
EOF

# Encrypt the file
if ! ansible-vault encrypt group_vars/all/vault.yml.tmp --output group_vars/all/vault.yml; then
    echo "Error: Failed to encrypt vault file" >&2
    rm -f group_vars/all/vault.yml.tmp
    exit 1
fi

rm -f group_vars/all/vault.yml.tmp

echo ""
echo "✓ Vault configured successfully!"
echo ""
echo "You can now run 'make setup' without password prompts."
echo ""
echo "To edit the vault later:"
echo "  cd ansible"
echo "  ansible-vault edit group_vars/all/vault.yml"
