#!/usr/bin/env python3
"""
Ansible Vault password script using GNOME Keyring (secret-tool).

This script retrieves the Ansible Vault password from the system keyring,
eliminating the need for manual password entry.

Setup:
    # Store the password in keyring (one-time)
    secret-tool store --label='Ansible Vault Password' ansible-vault hass-password

    # Verify it's stored
    secret-tool lookup ansible-vault hass-password
"""

import subprocess
import sys
import os

def get_vault_password():
    """Retrieve Ansible Vault password from GNOME Keyring."""

    # Check if running in headless environment
    if not os.environ.get('DISPLAY') and not os.environ.get('WAYLAND_DISPLAY'):
        print("Error: No display server detected. Cannot access GNOME Keyring.", file=sys.stderr)
        print("Hint: This script requires a graphical session with GNOME Keyring.", file=sys.stderr)
        return 1

    try:
        result = subprocess.run(
            ['secret-tool', 'lookup', 'ansible-vault', 'hass-password'],
            capture_output=True,
            text=True,
            check=True,
            timeout=5  # Add timeout to prevent hanging
        )
        # Print password to stdout (Ansible expects this)
        print(result.stdout.strip())
        return 0

    except subprocess.TimeoutExpired:
        print("Error: Timeout accessing keyring.", file=sys.stderr)
        print("Hint: GNOME Keyring may be locked or unresponsive.", file=sys.stderr)
        return 1

    except subprocess.CalledProcessError as e:
        print("Error: Password not found in keyring.", file=sys.stderr)
        print("Run: secret-tool store --label='Ansible Vault Password' ansible-vault hass-password", file=sys.stderr)
        if e.stderr:
            print(f"Details: {e.stderr}", file=sys.stderr)
        return 1

    except FileNotFoundError:
        print("Error: secret-tool not found. Install libsecret-tools.", file=sys.stderr)
        print("Run: sudo dnf install libsecret-tools", file=sys.stderr)
        return 1

    except Exception as e:
        print(f"Error: Unexpected error accessing keyring: {e}", file=sys.stderr)
        return 1

if __name__ == '__main__':
    sys.exit(get_vault_password())
