# Contributing to hass-ops

Thank you for your interest in contributing to hass-ops! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Code Standards](#code-standards)
- [Submitting Changes](#submitting-changes)
- [Testing](#testing)

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). By participating, you are expected to uphold this code.

## Getting Started

1. **Fork the repository** on your preferred Git platform
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/yourusername/hass-ops
   cd hass-ops
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/dzintars/hass-ops
   ```

## Development Setup

### Prerequisites

- Fedora Linux (42 or 43)
- Python 3.9+
- Git

### Initial Setup

1. **Install Python and Ansible**:
   ```bash
   sudo dnf install python3 python3-pip -y
   pip3 install --user ansible
   ```

2. **Install build prerequisites**:
   ```bash
   make setup
   ```

3. **Configure vault** (optional but recommended):
   ```bash
   ./scripts/setup-vault.sh
   ```
   See [docs/vault-setup.md](docs/vault-setup.md) for details.

4. **Install development tools**:
   ```bash
   pip3 install --user pre-commit ansible-lint yamllint
   pre-commit install
   ```

5. **Verify setup**:
   ```bash
   make build
   make test-vm
   ```

## Making Changes

### Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/my-feature
   ```

   Branch naming conventions:
   - `feature/` - New features
   - `fix/` - Bug fixes
   - `docs/` - Documentation changes
   - `refactor/` - Code refactoring
   - `test/` - Test additions/changes

2. **Make your changes**:
   - Write clear, concise code
   - Follow the code standards below
   - Add/update documentation as needed
   - Add/update tests if applicable

3. **Commit your changes**:
   ```bash
   git add .
   git commit
   ```
   Follow [Conventional Commits](https://www.conventionalcommits.org/):
   ```
   <type>(<scope>): <subject>

   <body>

   <footer>
   ```

   Examples:
   ```
   feat(ansible): add stress testing role
   fix(mkosi): correct boot configuration
   docs(readme): update quick start guide
   ```

4. **Keep your branch updated**:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

5. **Push to your fork**:
   ```bash
   git push origin feature/my-feature
   ```

6. **Create a Pull Request**:
   - Provide a clear title and description
   - Reference any related issues
   - Ensure all checks pass

## Code Standards

### Ansible

- **Use FQCN** (Fully Qualified Collection Names):
  ```yaml
  # Good
  - ansible.builtin.dnf:
      name: package

  # Bad
  - dnf:
      name: package
  ```

- **Follow role structure**:
  ```
  roles/role-name/
  ├── defaults/main.yml
  ├── tasks/main.yml
  ├── meta/main.yml
  ├── handlers/main.yml (if needed)
  └── README.md
  ```

- **Use meaningful variable names**:
  ```yaml
  # Good
  build_tools_packages:
    - mkosi
    - make

  # Bad
  packages:
    - mkosi
    - make
  ```

- **Run ansible-lint** before committing:
  ```bash
  cd ansible
  ansible-lint
  ```

### Shell Scripts

- **Use strict mode**:
  ```bash
  #!/bin/bash
  set -euo pipefail
  ```

- **Add error handling**:
  ```bash
  if ! command -v tool &> /dev/null; then
      echo "Error: tool not found" >&2
      exit 1
  fi
  ```

- **Run shellcheck**:
  ```bash
  shellcheck scripts/*.sh
  ```

### YAML

- **Use 2-space indentation**
- **Use `---` document start marker**
- **Use `...` document end marker** (optional)
- **Run yamllint**:
  ```bash
  yamllint .
  ```

### Makefile

- **Use `.PHONY` for non-file targets**
- **Add help text** with `##`:
  ```makefile
  target: ## Description of target
  	@command
  ```
- **Use `@echo` for user-facing output**

### Documentation

- **Use Markdown** for all documentation
- **Follow structure**:
  - Clear headings
  - Code blocks with language tags
  - Links to related docs
- **Update README.md** if adding features
- **Update CHANGELOG.md** following [Keep a Changelog](https://keepachangelog.com/)

## Submitting Changes

### Pull Request Checklist

Before submitting a PR, ensure:

- [ ] Code follows style guidelines
- [ ] Pre-commit hooks pass
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated (if applicable)
- [ ] Commits follow Conventional Commits
- [ ] Tests pass (when available)
- [ ] PR description is clear and complete

### PR Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, a maintainer will merge your PR
4. Your contribution will be included in the next release

## Testing

### Manual Testing

```bash
# Build the image
make build

# Test in VM
make test-vm

# Clean up
make clean
```

### Automated Testing

(Coming soon - molecule tests for Ansible roles)

## Questions?

- Open an issue for bugs or feature requests
- Start a discussion for questions or ideas
- Check existing issues and documentation first

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
