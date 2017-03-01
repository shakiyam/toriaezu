MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.SUFFIXES:

STAR_TARGETS := $(shell ./scripts/star_targets.sh $(MAKEFILE_LIST))
NON_PHONY_TARGETS := $(shell ./scripts/non_phony_targets.sh $(MAKEFILE_LIST))

.PHONY: toriaezu
toriaezu: $(STAR_TARGETS) ## Install star(*) tools
	@:

.PHONY: install_docker
install_docker: ## Install Docker Engine (*)
	@./scripts/install_docker.sh

install_docker-compose: install_docker ## Install Docker Compose (*)
	@./scripts/install_docker-compose.sh
	@touch $@

install_dockviz: install_docker ## Install dockviz
	@./scripts/install_dockviz.sh
	@touch $@

install_dotfiles: ## Install dotfiles (*)
	@./scripts/install_dotfiles.sh
	@touch $@

install_git: ## Install Git
	@./scripts/install_git.sh
	@touch $@

install_go: ## Install Go Programming Language
	@./scripts/install_go.sh
	@touch $@

install_hadolint: ## Install hadolint
	@./scripts/install_hadolint.sh
	@touch $@

install_micro: ## Install Micro
	@./scripts/install_micro.sh
	@touch $@

install_peco: ## Install peco (*)
	@./scripts/install_peco.sh
	@touch $@

install_q: ## Install Q
	@./scripts/install_q.sh
	@touch $@

install_shellcheck: ## Install ShellCheck
	@./scripts/install_shellcheck.sh
	@touch $@

install_tmux: ## Install tmux
	@./scripts/install_tmux.sh
	@touch $@

.PHONY: clean
clean: ## Clean target files
	@rm -f $(NON_PHONY_TARGETS)

.PHONY: list
list: ## List tools
	@./scripts/list.sh

.PHONY: help
help:  ## Print this help
	@./scripts/help.sh $(MAKEFILE_LIST)
