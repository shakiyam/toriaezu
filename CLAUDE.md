# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the **toriaezu** project - an environment setup tool that automates the installation of various development tools and utilities on Oracle Linux 8/9 and Ubuntu 24.04 LTS.

## Key Commands

### Build and Installation Commands
- `make help` - Show all available targets and their descriptions
- `make toriaezu` - Install all default (starred) tools
- `make all` - Install ALL available tools
- `make install_<tool>` - Install a specific tool (e.g., `make install_docker`)
- `make list` - List all available tools

### Development Commands
*Note: These development commands are not shown in `make help` but are available for development use*
- `make shellcheck` - Lint shell scripts
- `make shfmt` - Lint shell script formatting
- `make fishlint` - Lint Fish scripts
- `make hadolint` - Lint Dockerfile
- `make lint` - Run all linting tasks
- `make test-oraclelinux8` - Run Oracle Linux 8 test container
- `make test-oraclelinux9` - Run Oracle Linux 9 test container
- `make test-ubuntu24` - Run Ubuntu 24.04 test container

## Architecture

### Directory Structure
- `scripts/` - Individual installation scripts for each tool
- `bin/` - Utility scripts (dclogs, dcls)
- `Makefile` - Central build orchestration with dependency management
- `provision.sh` - Main entry point that runs `make toriaezu`

### Key Design Patterns
1. **Modular Installation**: Each tool has its own `install_*.sh` script in the `scripts/` directory
2. **Dependency Management**: Makefile handles inter-tool dependencies (e.g., csvq requires Go, most tools require mise)
3. **Version Management**: Many development tools use mise for consistent version management across environments
4. **Cross-Platform Support**: Scripts detect OS and use appropriate package manager (dnf for Oracle Linux, apt for Ubuntu) for system tools
5. **Star System**: Tools marked with (*) in Makefile comments are installed by default

### Installation Flow
1. User runs `./provision.sh`
2. Script sets up environment and calls `make toriaezu`
3. Makefile runs all star targets based on `scripts/star_targets.sh` output
4. Each installation script:
   - Checks if required dependencies (like mise) are available
   - Installs using appropriate method:
     - Development tools: via mise for version management
     - System tools: via package manager (dnf/apt)
     - Binary tools: direct download from GitHub releases
   - Activates mise environment when needed
   - Verifies installation success

### Code Standards
- Shell scripts follow strict bash practices with error handling
- Bash scripts (.sh) use 2-space indentation
- Fish scripts (.fish) use 4-space indentation
- Makefile uses tabs for indentation
- ShellCheck directives used where needed
- Scripts are designed to be idempotent