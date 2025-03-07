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

install_bash-completion: ## Install bash-completion (*)
	@./scripts/install_bash-completion.sh

install_ble: ## Install Bash Line Editor (*)
	@./scripts/install_ble.sh

install_chezmoi: ## Install chezmoi (*)
	@./scripts/install_chezmoi.sh

install_cho: ## Install cho (*)
	@./scripts/install_cho.sh

install_csvq: install_go ## Install csvq (*)
	@./scripts/install_csvq.sh

install_docker: install_jq ## Install Docker Engine (*)
	@./scripts/install_docker.sh

install_docker-compose: install_docker ## Install Docker Compose (*)
	@./scripts/install_docker-compose.sh

install_dockviz: install_docker install_go ## Install dockviz
	@./scripts/install_dockviz.sh

install_dtools: ## Install some docker tools (*)
	@./scripts/install_dtools.sh

install_enhancd: install_cho ## Install enhancd (*)
	@./scripts/install_enhancd.sh

install_fzy: ## Install fzy
	@./scripts/install_fzy.sh

install_git: ## Install Git (*)
	@./scripts/install_git.sh

install_go: ## Install Go Programming Language
	@./scripts/install_go.sh

install_hadolint: ## Install hadolint (*)
	@./scripts/install_hadolint.sh

install_java: ## Install OpenJDK Development Kit
	@./scripts/install_java.sh

install_jq: ## Install jq (*)
	@./scripts/install_jq.sh

install_kubectl: ## Install kubectl
	@./scripts/install_kubectl.sh

install_nfs: ## Install NFS client and mount
	@./scripts/install_nfs.sh

install_node: ## Install Node.js
	@./scripts/install_node.sh

install_oci: ## Install OCI CLI
	@./scripts/install_oci.sh

install_peco: ## Install peco
	@./scripts/install_peco.sh

install_regctl: ## Install regctl (*)
	@./scripts/install_regctl.sh

install_rg: ## Install rigrep (*)
	@./scripts/install_rg.sh

install_s3fs: ## Install s3fs
	@./scripts/install_s3fs.sh

install_shellcheck: ## Install ShellCheck (*)
	@./scripts/install_shellcheck.sh

install_shfmt: ## Install shfmt (*)
	@./scripts/install_shfmt.sh

install_tmux: ## Install tmux
	@./scripts/install_tmux.sh

install_unzip: ## Install UnZip (*)
	@./scripts/install_unzip.sh

install_zip: ## Install Zip (*)
	@./scripts/install_zip.sh

list: ## List tools
	@./scripts/list.sh

help: ## Print this help
	@./scripts/help.sh $(MAKEFILE_LIST)
