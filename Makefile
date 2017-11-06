MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.SUFFIXES:

ALL_TARGETS := $(shell egrep -o ^[0-9A-Za-z_-]+: $(MAKEFILE_LIST) | sed 's/://')
STAR_TARGETS := $(shell ./scripts/star_targets.sh $(MAKEFILE_LIST))

.PHONY: $(ALL_TARGETS)

toriaezu: $(STAR_TARGETS) ## Install star(*) tools
	@:

install_docker: ## Install Docker Engine (*)
	@./scripts/install_docker.sh

install_docker-compose: install_docker ## Install Docker Compose (*)
	@./scripts/install_docker-compose.sh

install_dockviz: install_docker ## Install dockviz
	@./scripts/install_dockviz.sh

install_dotfiles: ## Install dotfiles (*)
	@./scripts/install_dotfiles.sh

install_git: ## Install Git
	@./scripts/install_git.sh

install_go: ## Install Go Programming Language
	@./scripts/install_go.sh

install_hadolint: ## Install hadolint
	@./scripts/install_hadolint.sh

install_java: ## Install OpenJDK Development Kit
	@./scripts/install_java.sh

install_lv: ## Install lv
	@./scripts/install_lv.sh

install_micro: ## Install Micro
	@./scripts/install_micro.sh

install_node: ## Install Node.js
	@./scripts/install_node.sh

install_peco: ## Install peco (*)
	@./scripts/install_peco.sh

install_pt: ## Install The Platinum Searcher
	@./scripts/install_pt.sh

install_python: ## Install Python
	@./scripts/install_python.sh

install_q: ## Install Q
	@./scripts/install_q.sh

install_ruby: ## Install Ruby
	@./scripts/install_ruby.sh

install_s3fs: ## Install s3fs
	@./scripts/install_s3fs.sh

install_svfs: ## Install SVFS
	@./scripts/install_svfs.sh

install_shellcheck: ## Install ShellCheck
	@./scripts/install_shellcheck.sh

install_tmux: ## Install tmux
	@./scripts/install_tmux.sh

list: ## List tools
	@./scripts/list.sh

help: ## Print this help
	@./scripts/help.sh $(MAKEFILE_LIST)
