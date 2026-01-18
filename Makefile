# Makefile for hass-ops

# Build paths - single source of truth
BUILD_DIR := build
SERVER_BUILD_DIR := $(BUILD_DIR)/server
WORKSTATION_BUILD_DIR := $(BUILD_DIR)/workstation
SERVER_IMAGE := $(SERVER_BUILD_DIR)/hass-server_1.0.0.raw
WORKSTATION_IMAGE := $(WORKSTATION_BUILD_DIR)/hass-workstation_1.0.0.raw

.PHONY: help setup build test-vm clean

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \\033[36m%-20s\\033[0m %s\\n", $$1, $$2}'

setup: ## Install build prerequisites (mkosi, make, KVM, QEMU, libvirt)
	@echo "Installing build prerequisites..."
	@echo "NOTE: Configure vault to avoid password prompts. See docs/vault-setup.md"
	cd ansible && ansible-playbook playbooks/setup-workstation.yml
	@echo ""
	@echo "✓ Prerequisites installed successfully!"
	@echo "  You may need to log out and log back in for group changes to take effect."

build: build-server ## Build default (server) image

build-server: ## Build Fedora Server variant
	@echo "Building server image..."
	@START_TIME=$$(date +%s); \
	mkosi -C mkosi/server build; \
	END_TIME=$$(date +%s); \
	DURATION=$$((END_TIME - START_TIME)); \
	MINUTES=$$((DURATION / 60)); \
	SECONDS=$$((DURATION % 60)); \
	echo ""; \
	echo "✓ Server image built successfully!"; \
	echo "  Output: $(SERVER_IMAGE)"; \
	echo "  Build time: $${MINUTES}m $${SECONDS}s"

build-workstation: ## Build Fedora Workstation variant
	@echo "Building workstation image..."
	@START_TIME=$$(date +%s); \
	mkosi -C mkosi/workstation build; \
	END_TIME=$$(date +%s); \
	DURATION=$$((END_TIME - START_TIME)); \
	MINUTES=$$((DURATION / 60)); \
	SECONDS=$$((DURATION % 60)); \
	echo ""; \
	echo "✓ Workstation image built successfully!"; \
	echo "  Output: $(WORKSTATION_IMAGE)"; \
	echo "  Build time: $${MINUTES}m $${SECONDS}s"

build-all: ## Build all image variants
	@$(MAKE) build-server
	@$(MAKE) build-workstation

test-vm: ## Test image in QEMU/KVM
	@echo "Booting image in QEMU/KVM..."
	@echo "Press Ctrl+C to exit"
	@echo ""
	cd mkosi && mkosi qemu

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)
	rm -rf mkosi/server/mkosi.cache/
	rm -rf mkosi/workstation/mkosi.cache/
	rm -rf mkosi/server/*.raw mkosi/server/*.efi mkosi/server/*.initrd mkosi/server/*.vmlinuz
	rm -rf mkosi/workstation/*.raw mkosi/workstation/*.efi mkosi/workstation/*.initrd mkosi/workstation/*.vmlinuz
	@echo "✓ Clean complete"

write-usb: write-usb-server ## Write server image to USB (default)

write-usb-server: ## Write server image to USB (usage: make write-usb-server DEVICE=/dev/sde)
ifndef DEVICE
	@echo "Error: DEVICE not specified"
	@echo "Usage: make write-usb-server DEVICE=/dev/sde"
	@exit 1
endif
	@echo "WARNING: This will erase all data on $(DEVICE)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		sudo dd if=$(SERVER_IMAGE) of=$(DEVICE) bs=4M status=progress && sync; \
		echo "✓ Server image written to $(DEVICE)"; \
	else \
		echo "Cancelled"; \
	fi

write-usb-workstation: ## Write workstation image to USB (usage: make write-usb-workstation DEVICE=/dev/sde)
ifndef DEVICE
	@echo "Error: DEVICE not specified"
	@echo "Usage: make write-usb-workstation DEVICE=/dev/sde"
	@exit 1
endif
	@echo "WARNING: This will erase all data on $(DEVICE)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		sudo dd if=$(WORKSTATION_IMAGE) of=$(DEVICE) bs=4M status=progress && sync; \
		echo "✓ Workstation image written to $(DEVICE)"; \
	else \
		echo "Cancelled"; \
	fi
