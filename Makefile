# Makefile for hass-ops

.PHONY: help setup build test-vm clean

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Install build prerequisites (mkosi, make, KVM, QEMU, libvirt)
	@echo "Installing build prerequisites..."
	@echo "NOTE: Configure vault to avoid password prompts. See docs/vault-setup.md"
	cd ansible && ansible-playbook playbooks/setup-workstation.yml
	@echo ""
	@echo "✓ Prerequisites installed successfully!"
	@echo "  You may need to log out and log back in for group changes to take effect."

build: ## Build bootable Fedora image
	@echo "Building bootable Fedora 43 image..."
	@START_TIME=$$(date +%s); \
	cd mkosi && mkosi; \
	END_TIME=$$(date +%s); \
	DURATION=$$((END_TIME - START_TIME)); \
	MINUTES=$$((DURATION / 60)); \
	SECONDS=$$((DURATION % 60)); \
	echo ""; \
	echo "✓ Image built successfully!"; \
	echo "  Output: build/hass-validator_1.0.0.raw"; \
	echo "  Build time: $${MINUTES}m $${SECONDS}s"

test-vm: ## Test image in QEMU/KVM
	@echo "Booting image in QEMU/KVM..."
	@echo "Press Ctrl+C to exit"
	@echo ""
	cd mkosi && mkosi qemu

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	rm -rf build/
	rm -rf mkosi/mkosi.cache/
	rm -rf mkosi/*.raw mkosi/*.efi mkosi/*.initrd mkosi/*.vmlinuz
	@echo "✓ Clean complete"

write-usb: ## Write image to USB drive (usage: make write-usb DEVICE=/dev/sdb)
ifndef DEVICE
	@echo "Error: DEVICE not specified"
	@echo "Usage: make write-usb DEVICE=/dev/sdb"
	@exit 1
endif
	@echo "WARNING: This will erase all data on $(DEVICE)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		sudo dd if=build/hass-validator_1.0.0.raw of=$(DEVICE) bs=4M status=progress && sync; \
		echo "✓ Image written to $(DEVICE)"; \
	else \
		echo "Cancelled"; \
	fi
