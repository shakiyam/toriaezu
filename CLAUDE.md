# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the **toriaezu** project - a Bash-based developer environment setup tool that automates the installation of various development tools and utilities on Oracle Linux 8/9 and Ubuntu 22.04 LTS.

## Key Commands

### Build and Installation Commands
- `make help` - Show all available targets and their descriptions
- `make toriaezu` - Install all default (starred) tools
- `make all` - Install ALL available tools
- `make install_<tool>` - Install a specific tool (e.g., `make install_docker`)
- `make list` - List all available tools

### Development Commands
- `shellcheck scripts/*.sh` - Run ShellCheck on all shell scripts
- `shfmt -d scripts/*.sh` - Check shell script formatting (use `-w` to fix)

## Architecture

### Directory Structure
- `scripts/` - Individual installation scripts for each tool
- `bin/` - Utility scripts (dclogs, dcls, hadolint)
- `Makefile` - Central build orchestration with dependency management
- `provision.sh` - Main entry point that runs `make toriaezu`

### Key Design Patterns
1. **Modular Installation**: Each tool has its own `install_*.sh` script in the `scripts/` directory
2. **Dependency Management**: Makefile handles inter-tool dependencies (e.g., csvq requires Go)
3. **Cross-Platform Support**: Scripts detect OS and use appropriate package manager (dnf for Oracle Linux, apt for Ubuntu)
4. **Error Handling**: All scripts use `set -eu -o pipefail` for strict error handling
5. **Star System**: Tools marked with (*) in Makefile comments are installed by default

### Installation Flow
1. User runs `./provision.sh`
2. Script sets up environment and calls `make toriaezu`
3. Makefile runs all star targets based on `scripts/star_targets.sh` output
4. Each installation script:
   - Checks if tool is already installed
   - Installs using appropriate method (package manager, binary download, or source)
   - Verifies installation success

### Code Standards
- Shell scripts follow strict bash practices with error handling
- Consistent 2-space indentation (4-space tabs in Makefile)
- ShellCheck directives used where needed
- Scripts are designed to be idempotent