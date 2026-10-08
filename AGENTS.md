# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the **toriaezu** project - an environment setup tool that automates the installation of various development tools and utilities on Oracle Linux 8/9 and Ubuntu 24.04/26.04 LTS.

## Key Commands

### Build and Installation Commands

- `make help` - Show all available targets and their descriptions
- `make toriaezu` - Install default tools (same as `make base`)
- `make base` / `make dev` / `make container` - Install a tool group (base, development, or container tools)
- `make all` - Install ALL available tools
- `make install_<tool>` - Install a specific tool (e.g., `make install_docker`)
- `make list` - List all available tools

### Development Commands

*Note: Use `make help-dev` to see all development targets*

- `make help-dev` - Show all development targets (also shown in `make help`)
- `make lint` - Run all linting tasks
- `make shellcheck` - Lint shell scripts
- `make shfmt` - Lint shell script formatting
- `make fishlint` - Lint Fish scripts
- `make hadolint` - Lint Dockerfile
- `make test` - Run installation tests in all containers
- `make test-history-cleanup` - Run history-cleanup tests with isolated histories
- `make test-oraclelinux8` - Run installation tests in Oracle Linux 8 container
- `make test-oraclelinux9` - Run installation tests in Oracle Linux 9 container
- `make test-ubuntu24` - Run installation tests in Ubuntu 24.04 container
- `make test-ubuntu26` - Run installation tests in Ubuntu 26.04 container
- `make shell-oraclelinux8` - Open a shell in Oracle Linux 8 test container
- `make shell-oraclelinux9` - Open a shell in Oracle Linux 9 test container
- `make shell-ubuntu24` - Open a shell in Ubuntu 24.04 test container
- `make shell-ubuntu26` - Open a shell in Ubuntu 26.04 test container

## Architecture

### Directory Structure

- `scripts/` - Individual installation scripts for each tool
- `bin/` - Utility scripts (bash or fish) installed to `~/.local/bin` by `install_*.sh`
- `tests/` - Tests for utility scripts, run by `make test-<utility>`
- `Makefile` - Central build orchestration with dependency management
- `provision.sh` - Main entry point that runs `make toriaezu`

### Key Design Patterns

1. **Modular Installation**: Each tool has its own `install_*.sh` script in the `scripts/` directory
2. **Dependency Management**: Makefile handles inter-tool dependencies (e.g., csvq requires Go, most tools require mise)
3. **Version Management**: Many development tools use mise for consistent version management across environments
4. **Cross-Platform Support**: Scripts detect OS and use appropriate package manager (dnf for Oracle Linux, apt for Ubuntu) for system tools
5. **Tool Groups**: `BASE_TARGETS`, `DEV_TARGETS`, and `CONTAINER_TARGETS` in Makefile list the install targets of each group explicitly; tools in no group are installed individually

### Installation Flow

1. User runs `./provision.sh`
2. Script sets up environment and calls `make toriaezu`, or `make` with the given arguments (e.g., `./provision.sh base dev container`)
3. Makefile runs the install targets of the requested groups and their dependencies
4. Each installation script:
   - Checks if required dependencies (like mise) are available
   - Installs using appropriate method:
     - Most tools: via mise, using the registry short name by default, or an explicit backend (`aqua:`, `github:`, `go:`) when the tool is not in the registry or its default build does not run on a target OS (see each `install_*.sh`)
     - System tools: via package manager (dnf/apt)
     - Others (e.g., mise itself, Fisher): direct download
   - Activates mise environment when needed
   - Verifies installation success

### Code Standards

- Shell scripts follow strict bash practices with error handling
- Bash scripts (.sh) use 2-space indentation
- Fish scripts (.fish) use 4-space indentation
- Makefile uses tabs for indentation
- ShellCheck directives used where needed
- Scripts are designed to be idempotent

### Makefile Comment Markers

- `##` - User-facing targets (shown in `make help`)
- `#@` - Developer-facing targets (shown in `make help-dev` only)
