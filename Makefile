MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
ALL_TARGETS := $(shell grep -E -o ^[0-9A-Za-z_-]+: $(MAKEFILE_LIST) | sed 's/://')
.PHONY: $(ALL_TARGETS)
.DEFAULT_GOAL := help

ALL_INSTALL_TARGETS := $(shell grep -E -o ^install_[0-9A-Za-z_-]+: $(MAKEFILE_LIST) | sed 's/://')
all: $(ALL_INSTALL_TARGETS)
	@:

STAR_TARGETS := $(shell ./scripts/star_targets.sh $(MAKEFILE_LIST))
toriaezu: $(STAR_TARGETS) ## Install star(*) tools
	@:

install_bat: ## Install bat (*)
	@./scripts/install_bat.sh

install_chezmoi: ## Install chezmoi (*)
	@./scripts/install_chezmoi.sh

install_claude-code: install_node ## Install Claude Code
	@./scripts/install_claude-code.sh

install_csvq: install_go ## Install csvq (*)
	@./scripts/install_csvq.sh

install_docker: ## Install Docker Engine (*)
	@./scripts/install_docker.sh

install_docker-compose: install_docker ## Install Docker Compose (*)
	@./scripts/install_docker-compose.sh

install_dockerfmt: ## Install dockerfmt
	@./scripts/install_dockerfmt.sh

install_dockviz: install_docker install_go ## Install dockviz
	@./scripts/install_dockviz.sh

install_dtools: install_fzf ## Install some docker tools (*)
	@./scripts/install_dtools.sh

install_enhancd: install_fisher install_fzf ## Install enhancd (*)
	@./scripts/install_enhancd.fish

install_eza: ## Install eza (*)
	@./scripts/install_eza.sh

install_fzf: ## Install fzf (*)
	@./scripts/install_fzf.sh

install_fish: ## Install fish shell (*)
	@./scripts/install_fish.sh

install_fisher: install_fish ## Install Fisher (*)
	@./scripts/install_fisher.fish

install_git: ## Install Git (*)
	@./scripts/install_git.sh

install_go: ## Install Go Programming Language
	@./scripts/install_go.sh

install_hadolint: ## Install hadolint (*)
	@./scripts/install_hadolint.sh

install_jq: ## Install jq (*)
	@./scripts/install_jq.sh

install_kubectl: ## Install kubectl
	@./scripts/install_kubectl.sh

install_mise: ## Install mise (*)
	@./scripts/install_mise.sh

install_nfs: ## Install NFS client and mount
	@./scripts/install_nfs.sh

install_node: ## Install Node.js
	@./scripts/install_node.sh

install_oci: ## Install OCI CLI
	@./scripts/install_oci.sh

install_regctl: ## Install regctl (*)
	@./scripts/install_regctl.sh

install_rg: ## Install rigrep (*)
	@./scripts/install_rg.sh

install_s3fs: ## Install s3fs
	@./scripts/install_s3fs.sh

install_shellcheck: install_xz ## Install ShellCheck (*)
	@./scripts/install_shellcheck.sh

install_shfmt: ## Install shfmt (*)
	@./scripts/install_shfmt.sh

install_tmux: ## Install tmux
	@./scripts/install_tmux.sh

install_unzip: ## Install UnZip (*)
	@./scripts/install_unzip.sh

install_xz: ## Install xz (*)
	@./scripts/install_xz.sh

install_zip: ## Install Zip (*)
	@./scripts/install_zip.sh

list: ## List tools
	@./scripts/list.sh

help: ## Print this help
	@./scripts/help.sh $(MAKEFILE_LIST)

shellcheck: # Lint shell scripts
	@shellcheck provision.sh bin/* scripts/*.sh

shfmt: # Lint shell script formatting
	@shfmt -l -d -i 2 -ci -bn provision.sh bin/* scripts/*.sh

fishlint: # Lint Fish scripts
	@./scripts/fishlint.fish scripts/*.fish

hadolint: # Lint Dockerfiles
	@hadolint Dockerfile

lint: shellcheck shfmt fishlint hadolint # Run all linting tasks
	@echo "All linting tasks completed"

test-oraclelinux8: # Run Oracle Linux 8 test container
	@docker compose run --rm oraclelinux8

test-oraclelinux9: # Run Oracle Linux 9 test container
	@docker compose run --rm oraclelinux9

test-ubuntu24: # Run Ubuntu 24.04 test container
	@docker compose run --rm ubuntu24

test: # Run automated tests in all Docker containers
	@echo "Running automated tests..."
	@echo "Testing Oracle Linux 8..."
	@docker compose run --rm oraclelinux8 /home/testuser/toriaezu/scripts/test_installation.sh
	@echo "Testing Oracle Linux 9..."
	@docker compose run --rm oraclelinux9 /home/testuser/toriaezu/scripts/test_installation.sh
	@echo "Testing Ubuntu 24.04..."
	@docker compose run --rm ubuntu24 /home/testuser/toriaezu/scripts/test_installation.sh
	@echo "All tests completed"
