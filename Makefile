MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.SUFFIXES:

ALL_TARGETS := $(shell egrep -o ^[0-9A-Za-z_-]+: $(MAKEFILE_LIST) | sed 's/://')
ALL_INSTALL_TARGETS := $(shell egrep -o ^[0-9A-Za-z_-]+: $(MAKEFILE_LIST) | grep install_ | sed 's/://')
STAR_TARGETS := $(shell ./scripts/star_targets.sh $(MAKEFILE_LIST))

.PHONY: $(ALL_TARGETS)

all: $(ALL_INSTALL_TARGETS)
	@:

toriaezu: $(STAR_TARGETS) ## Install star(*) tools
	@:

install_bash-completion: ## Install bash-completion (*)
	@./scripts/install_bash-completion.sh

install_ble: ## Install Bash Line Editor (*)
	@./scripts/install_ble.sh

install_checkstyle: install_java ## Install Checkstyle
	@./scripts/install_checkstyle.sh

install_csvq: ## Install csvq (*)
	@./scripts/install_csvq.sh

install_docker: install_jq ## Install Docker Engine (*)
	@./scripts/install_docker.sh

install_docker-compose: install_docker ## Install Docker Compose (*)
	@./scripts/install_docker-compose.sh

install_dockviz: install_docker ## Install dockviz
	@./scripts/install_dockviz.sh

install_dotfiles: ## Install dotfiles (*)
	@./scripts/install_dotfiles.sh

install_dtools: ## Install some docker tools (*)
	@./scripts/install_dtools.sh

install_enhancd: install_fzy ## Install enhancd (*)
	@./scripts/install_enhancd.sh

install_fzy: ## Install fzy (*)
	@./scripts/install_fzy.sh

install_git: ## Install Git (*)
	@./scripts/install_git.sh

install_go: ## Install Go Programming Language
	@./scripts/install_go.sh

install_hadolint: ## Install hadolint (*)
	@./scripts/install_hadolint.sh

install_java: ## Install OpenJDK Development Kit
	@./scripts/install_java.sh

install_jobber: ## Install Jobber
	@./scripts/install_jobber.sh

install_jq: ## Install jq
	@./scripts/install_jq.sh

install_nfs: ## Install NFS client and mount
	@./scripts/install_nfs.sh

install_node: ## Install Node.js
	@./scripts/install_node.sh

install_oci: ## Install OCI CLI
	@./scripts/install_oci.sh

install_peco: ## Install peco
	@./scripts/install_peco.sh

install_phpcs: ## Install PHP_CodeSniffer
	@./scripts/install_phpcs.sh

install_pt: ## Install The Platinum Searcher
	@./scripts/install_pt.sh

install_python3: ## Install Python3
	@./scripts/install_python3.sh

install_rg: ## Install rigrep (*)
	@./scripts/install_rg.sh

install_rubocop: ## Install RuboCop
	@./scripts/install_rubocop.sh

install_ruby: ## Install Ruby
	@./scripts/install_ruby.sh

install_s3fs: ## Install s3fs
	@./scripts/install_s3fs.sh

install_shellcheck: ## Install ShellCheck (*)
	@./scripts/install_shellcheck.sh

install_shfmt: ## Install shfmt (*)
	@./scripts/install_shfmt.sh

install_tmux: ## Install tmux (*)
	@./scripts/install_tmux.sh

install_unzip: ## Install UnZip (*)
	@./scripts/install_unzip.sh

install_zip: ## Install Zip (*)
	@./scripts/install_zip.sh

list: ## List tools
	@./scripts/list.sh

help: ## Print this help
	@./scripts/help.sh $(MAKEFILE_LIST)
