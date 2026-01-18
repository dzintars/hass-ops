# Security Policy

## Reporting Vulnerabilities

If you discover a security vulnerability in hass-ops, please report it responsibly:

**Email**: dzintars.dev@gmail.com

**Please include**:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

**Response time**: We aim to respond within 48 hours.

## Supported Versions

We support the latest release only. Please ensure you're using the most recent version before reporting issues.

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| Older   | :x:                |

## Security Practices

This project follows these security practices:

### Secrets Management

- ✅ **All secrets stored in Ansible Vault**
- ✅ **Vault password in GNOME Keyring** (not in repository)
- ✅ **No hardcoded credentials** in code
- ✅ **`.gitignore` configured** to exclude sensitive files

### Code Security

- ✅ **Shell scripts use strict mode** (`set -euo pipefail`)
- ✅ **Input validation** in scripts
- ✅ **Error handling** for external commands
- ✅ **Minimal permissions** for services

### Dependencies

- 🔄 **Regular updates** of Ansible collections
- 🔄 **Pin versions** in requirements files
- 🔄 **Review dependencies** before adding

### Infrastructure

- ✅ **Principle of least privilege**
- ✅ **Encrypted communication** where applicable
- ✅ **Audit logging** (planned)

## Security Checklist for Contributors

When contributing, please ensure:

- [ ] No secrets committed to repository
- [ ] Vault files are encrypted
- [ ] Scripts use error handling
- [ ] Dependencies are from trusted sources
- [ ] Code follows security best practices

## Known Security Considerations

### Ansible Vault

- Vault password must be stored securely in GNOME Keyring
- Vault files should never be committed unencrypted
- Use `ansible-vault encrypt` for new vault files

### Build Environment

- Build process requires sudo access (for package installation)
- KVM/QEMU require specific user groups (`libvirt`, `kvm`)
- Ensure build environment is trusted

### VM Images

- Images built with mkosi include packages from Fedora repositories
- Verify package sources before building production images
- Test images in isolated environments first

## Disclosure Policy

- Security issues are handled privately until a fix is available
- We will credit reporters (unless they prefer to remain anonymous)
- Public disclosure after fix is released

## Contact

For security concerns: dzintars.dev@gmail.com
For general questions: Open an issue on the repository

---

**Last Updated**: 2026-01-17
